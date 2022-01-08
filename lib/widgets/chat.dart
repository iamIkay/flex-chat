import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatUsersList extends StatefulWidget{
  String text;
  String secondaryText;
  String image;
  String time;
  bool isMessageRead;
  Function? onTap;
  ChatUsersList({required this.text,required this.secondaryText,required this.image, required this.time, required this.isMessageRead, required this.onTap});
  @override
  _ChatUsersListState createState() => _ChatUsersListState();
}

class _ChatUsersListState extends State<ChatUsersList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
       widget.onTap;
      },
      child: Container(
        padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.image),
                    maxRadius: 30,
                  ),
                  SizedBox(width: 16,),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.text),
                          SizedBox(height: 6,),

                          Text(widget.secondaryText,style: TextStyle(fontSize: 14,color: Colors.grey.shade500),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(widget.time,style: TextStyle(fontSize: 12,color: widget.isMessageRead?Colors.pink:Colors.grey.shade500),),
          ],
        ),
      ),
    );
  }

  getLastMessage(){

  }

  getStreamBuilder(){
    StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("chats")
            .doc('nVesnCuA3u3npfGp3BYp')
            .collection("messages")
            .orderBy('createdOn', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

          if(snapshot.hasError){
            return Center (child: Text("Something went wrong"),);
          }

          if(snapshot.connectionState == ConnectionState.waiting){
            return Center (child: Text("Loading..."),);
          }

          if(snapshot.hasData) {
            var data = snapshot.data;


/*
              ChatUsersList(
              onTap: () => _callChatScreen(context, data['name'], data['uid']),
              text: "New Message",
              secondaryText: data['msg'],
              image: "assets/whatsapp-logo.png",
              isMessageRead: true,
              time: dateToString(data['createdOn'].toDate()),); */
          }
          return Container();
        });
  }
}