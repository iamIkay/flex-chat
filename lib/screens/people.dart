import 'dart:developer';
import 'package:chat_app/chat_detail.dart';
import 'package:chat_app/custom_text.dart';
import 'package:chat_app/palette.dart';
import 'package:chat_app/providers/theme_provider.dart';
import 'package:chat_app/themes/themes.dart';
import 'package:chat_app/widgets/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({Key? key}) : super(key: key);

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

User? user = FirebaseAuth.instance.currentUser;
var currentUser = user!.uid;
var userDoc;
CollectionReference users = FirebaseFirestore.instance.collection("users");

class _PeopleScreenState extends State<PeopleScreen> {
  _callChatScreen(BuildContext context, String username, String uid){
    Navigator.push(context, CupertinoPageRoute(builder: (context)=> ChatDetail(friendUid:uid, friendName: username)));
  }
  var friends;
  @override
  void initState() {
    //super.initState();
    getFriends();
  }

  void getFriends() async {
    await users
        .where("uid", isEqualTo: currentUser)
        .limit(1)
        .get()
        .then((snapshot) {
      friends = (snapshot.docs.single['friends']);
      userDoc = snapshot.docs.single.id;

      setState(() {});
    }).catchError((error) {
      log(error.toString());
    });
  }

  var chatDocId;

  void checkUser(String friendUid) async {
    await chats
        .where('users', isEqualTo: {friendUid: null, currentUser: null})
        .limit(1)
        .get()
        .then(
          (QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          friends!.add(friendUid);

          users.doc(userDoc).update({"friends": friends}).then(
                  (value) => log("List updated"));

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

            friends!.add(friendUid);

            users.doc(userDoc).update({"friends": friends}).then((value) {
              setState(() {
                log("List updated");
              });
            });
          });
        }
      },
    )
        .catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);


    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where('name', isNotEqualTo: FirebaseAuth.instance.currentUser!.displayName)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text("Loading..."),
            );
          }

          if (snapshot.hasData) {
            return SafeArea(
              top: false,
              child: CustomScrollView(slivers: [
                CupertinoSliverNavigationBar(
                  automaticallyImplyLeading: false,
                  largeTitle:
                  const Text("Contacts", style: TextStyle(fontSize: 28.0)),
                  trailing: Material(
                      color: Colors.transparent,
                      child: IconButton(
                          icon: Icon(Icons.more_vert, color: themeProvider.getTheme == Themes.darkTheme ? Colors.grey : Colors.black.withOpacity(0.7)
                          ),
                          onPressed: ()=> getFriends()),),
                ),
                SliverList(
                    delegate: (SliverChildListDelegate(
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _callChatScreen(context,
                                  data['name'], data['uid']),
                              child: Container(
                                padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: (){},
                                      child: CircleAvatar(
                                        backgroundColor: themeProvider.getTheme == Themes.darkTheme ? Colors.black : Colors.white,
                                        backgroundImage:
                                        AssetImage("assets/${data['image']}"),
                                        //maxRadius: 30,
                                        radius: 30.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(data['name'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18.0,
                                                  color: themeProvider.getTheme == Themes.darkTheme ? Colors.white : Palette.primaryTextColor
                                                )),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(data['status'],
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.grey
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList())))
              ]),
            );
          }
          return Container();
        });
  }
}
