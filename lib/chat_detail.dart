import 'dart:developer';
import 'dart:io';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/chat_message.dart';
import 'models/send_menu_items.dart';

class ChatDetail extends StatefulWidget {
  final friendUid;
  final friendName;

  const ChatDetail({this.friendUid, this.friendName, Key? key})
      : super(key: key);

  @override
  _ChatDetailState createState() => _ChatDetailState(friendUid, friendName);
}

CollectionReference chats = FirebaseFirestore.instance.collection("chats");
FirebaseStorage _storage = FirebaseStorage.instance;

class _ChatDetailState extends State<ChatDetail> {
  final friendUid;
  final friendName;
  final currentUser = FirebaseAuth.instance.currentUser!.uid;

  _ChatDetailState(this.friendUid, this.friendName);

  var chatDocId;
  var _textController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() async {
    await chats
        .where('users', isEqualTo: {friendUid: null, currentUser: null})
        .limit(1)
        .get()
        .then(
          (QuerySnapshot querySnapshot) async {
            if (querySnapshot.docs.isNotEmpty) {
              setState(() {
                chatDocId = querySnapshot.docs.single.id;
              });
            } else {
              await chats.add({
                'users': {currentUser: null, friendUid: null},
                'userslist': [currentUser, friendUid],
                'last_updated': FieldValue.serverTimestamp()
              }).then((value) {
                chatDocId = value.id;

              });
              setState(() {

              });
            }
          },
        )
        .catchError((error) {});
  }

  final ScrollController _controller = ScrollController();

  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent + 100.0,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage(String msg, MessageType type) {
    if (msg == '') return;
    chats.doc(chatDocId).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'uid': currentUser,
      'msg': msg,
      'read': false,
      'type': type.index
    }).then((value) {

      _textController.text = '';
//      _scrollDown();
      chats
          .doc(chatDocId)
          .update({"last_updated": FieldValue.serverTimestamp()});


    });
  }

  bool isSender(String friend) {
    return friend == currentUser;
  }

  Alignment getAlignment(friend) {
    if (friend == currentUser) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }


  List<SendMenuItems> menuItems = [
    SendMenuItems(text: "Photos", icons: Icons.image, color: Colors.amber, fileType: FileType.image),
    SendMenuItems(text: "Videos", icons: Icons.image, color: Colors.amber, fileType: FileType.video),
    SendMenuItems(text: "Document", icons: Icons.insert_drive_file, color: Colors.blue, fileType: FileType.any),
  ];


  void showModal(){
    showCupertinoModalPopup(
        context: context,
        builder: (context){
          return Container(
           height: MediaQuery.of(context).size.height/2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 16,),
                  Center(
                    child: Container(
                     height: 4,
                      width: 50,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  SizedBox(height: 10,),
                  ListView.builder(
                    itemCount: menuItems.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index){
                      return Material(
                        child: InkWell(
                          onTap: () => showFilePicker(menuItems[index].fileType),
                          child: Container(
                            padding: EdgeInsets.only(top: 10,bottom: 10),
                            child: ListTile(
                              leading: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: menuItems[index].color.shade50,
                                ),
                                height: 50,
                                width: 50,
                                child: Icon(menuItems[index].icons,size: 20,color: menuItems[index].color.shade400,),
                              ),
                              title: Text(menuItems[index].text),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {

    //WidgetsBinding.instance!.addPostFrameCallback((timeStamp) => _scrollDown());


    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          previousPageTitle: "Chats",
          middle: Text(friendName),
        ),
        child: StreamBuilder<QuerySnapshot>(
            stream: chats
                .doc(chatDocId)
                .collection('messages')
                .orderBy('createdOn', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Something went wrong"),
                );
              }

              if (snapshot.hasData) {
                var data;
                for(int i = 0; i<snapshot.data!.size; i++){
                  var msg = snapshot.data!.docs[i];
                  if(msg['read'] == false && msg['uid'] != currentUser){
                    msg['msg'];
                    chats.doc(chatDocId).collection("messages").doc(msg.id).update({"read": true});
                  }
                }


                return SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                         reverse: true,
                          controller: _controller,
                          //dragStartBehavior: DragStartBehavior.down,
                          children: snapshot.data!.docs.map(
                            (DocumentSnapshot document) {
                              data = document.data()!;
                              return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child:

                                ChatBubble(
                                    chatMessage: ChatMessage(
                                        message: data['msg'],
                                        uid: data['uid'].toString(),
                                        isRead: data['read'],
                                        time: data['createdOn'],
                                      type: data['type'] == 0 ? MessageType.text : MessageType.image
                                    ),
                                  )

                                  //
                                  );
                            },
                          ).toList(),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 16,bottom: 10),
                        //height: 50,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){
                             showModal();
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Icon(CupertinoIcons.paperclip,color: Colors.white,size: 21,),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: CupertinoTextField(
                                  maxLines: 5,
                                  minLines: 1,
                                  placeholder: "message",
                                  controller: _textController,
                                ),
                              ),
                            ),

                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                //padding: EdgeInsets.only(right: 30,bottom: 50),
                                child: CupertinoButton(
                                    //color: Colors.black,
                                    child: Icon(Icons.send_sharp),
                                    onPressed: () =>
                                        sendMessage(_textController.text, MessageType.text)
                              ),
                            ))

                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
              return Container();
            }));

  }

  showFilePicker(FileType fileType) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: fileType);

    if (result != null) {
      Navigator.pop(context);

     // final reference = _storage.ref().child("images/");

      final filePath = result.files.single.path;

      final fileName = result.files.single.name;

      File file = File(filePath!);

      String? uri;

      try {
        await _storage.ref("images/$fileName").putFile(file).then((snapshot) {
          log("Done ${snapshot.ref}");
        uri = snapshot.ref.fullPath;});

        sendMessage(uri!, MessageType.image);
      }
      on FirebaseException catch(e) {
        log(e.toString());
      }



    } else {
      // User canceled the picker
    }
    /*File file = await FilePicker.platform.pickFiles(type: fileType);
    chatBloc.dispatch(SendAttachmentEvent(chat.chatId,file,fileType));
    Navigator.pop(context);
    GradientSnackBar.showMessage(context, 'Sending attachment..');*/
  }




 /* Future<Widget> _getImage(BuildContext context, String image) async {
    Image m;
    await FireStorageService.loadFromStorage(context, image).then((downloadUrl) {
      m = Image.network(
        downloadUrl.toString(),
        fit: BoxFit.scaleDown,
      );
    });

    return m;
  }*/


}

