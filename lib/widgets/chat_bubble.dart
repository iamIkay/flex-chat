import 'dart:developer';
import 'dart:ui';

import 'package:chat_app/models/chat_message.dart';
import 'package:chat_app/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../custom_text.dart';

class ChatBubble extends StatefulWidget{
  ChatMessage chatMessage;
  ChatBubble({required this.chatMessage});
  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}


String dateToString(DateTime date){

  final now = DateTime.now();
  String dateString = "";
  final dateToCheck = DateTime(date.year, date.month, date.day);

  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  //final tomorrow = DateTime(now.year, now.month, now.day + 1);

  if(dateToCheck == today){
    var minute = '${date.minute}';
    if(date.minute < 10){
      minute = '0${date.minute}';
    }

    dateString = '${date.hour}:$minute';
  }

  else if(dateToCheck == yesterday){
    dateString = "Yesterday";
  }

  else{
    dateString = "${date.day}/${date.month}/${date.year}";
  }


  return dateString;
}

class _ChatBubbleState extends State<ChatBubble> {
  final currentUser = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16,right: 16,top: 5),
      margin: isSender(widget.chatMessage.uid) ? EdgeInsets.only(right: 50.0) : EdgeInsets.only(left: 50.0),
      child: Align(
        alignment: (isSender(widget.chatMessage.uid) ? Alignment.topLeft:Alignment.topRight),
        child: Card(
          elevation: 10.0,
          color: Colors.transparent,
          child: Container(
            decoration: getBottomPointer(),
            padding: widget.chatMessage.type == MessageType.text ? EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 5.0) : EdgeInsets.fromLTRB(3.0, 5.0, 3.0, 5.0),
            child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      //alignment: isSender(widget.chatMessage.uid) ? Alignment.topLeft :  Alignment.topLeft,
                      width : widget.chatMessage.message.length <= 6 ? MediaQuery.of(context).size.width * 0.15 : null,
                        //padding: EdgeInsets.only(),
                        child: widget.chatMessage.type == MessageType.text ? Text(widget.chatMessage.message) : Container(
                          height: 200.0,
                          width: 180.0,
                          child: Image.asset("assets/dog.jpg", fit: BoxFit.fill),
                        )//buildImage(widget.chatMessage.message)
                    ),

                    Container(
                      child: Row(
                        textDirection: TextDirection.ltr,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Ctext(widget.chatMessage.time == null
                              ? dateToString(DateTime.now())
                              : dateToString(widget.chatMessage.time!
                              .toDate()),
                            align: TextAlign.left,
                            size: 9.0,

                          ),
                        ],
                      ),
                    ),
                  ],
                ),

          ),
        ),
      ),
    );
  }

  BoxDecoration getBottomPointer(){
    if(isSender(widget.chatMessage.uid)) {
      return BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.zero,
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
        color: Colors.grey.shade100
      );
    }
    else{
      return BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.zero,
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),),
        color: widget.chatMessage.isRead == true ? Palette.primaryColor : Colors.grey

      );
    }

  }
  bool isSender(String uid) {
    return uid != currentUser;
  }

  CrossAxisAlignment align(){
    return CrossAxisAlignment.end;
  }

 Widget buildImage(String uri) {
    log("THE URI : $uri");
    return FutureBuilder(
        future: downloadUrl(uri),
        builder: (context, AsyncSnapshot<String> snapshot){

          if(snapshot.connectionState == ConnectionState.waiting){
            return  SizedBox(
              height: 200.0,
              width: 180.0,
             // child: //Center(child: Text("Fetching media")),
            );
          }

          if(snapshot.hasError){
            return Container(
              height: 200.0,
              width: 180.0,
              child: Center(child: Text("Error loading media")),
            );
          }

          if(snapshot.hasData){
            return Container(
              height: 200.0,
              width: 180.0,
              child: Image.network(snapshot.data!, fit: BoxFit.fill,),
            );
          }

          return Text("omo");

        });
 }

  Future<String> downloadUrl(String data) async{
    FirebaseStorage _storage = FirebaseStorage.instance;

    String downloadURl = await _storage.ref(data).getDownloadURL();

    return downloadURl;
  }

}