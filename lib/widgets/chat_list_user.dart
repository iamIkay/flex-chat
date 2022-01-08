import 'dart:developer';

import 'package:chat_app/custom_text.dart';
import 'package:chat_app/palette.dart';
import 'package:chat_app/providers/theme_provider.dart';
import 'package:chat_app/screens/people.dart';
import 'package:chat_app/themes/themes.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../chat_detail.dart';

class ChatUser extends StatefulWidget {
  String currentUser;
  String friendDoc;
  Map<String, dynamic> users;
  DateTime timestamp;
  ChatUser(
      {required this.currentUser,
      required this.friendDoc,
      required this.timestamp,
      required this.users});
  @override
  _ChatUserState createState() => _ChatUserState();
}

_callChatScreen(BuildContext context, String username, String uid) {

  Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) =>
              ChatDetail(friendUid: uid, friendName: username)));
}

var themeProvider;
CollectionReference? chatDoc;
class _ChatUserState extends State<ChatUser> {


  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);

    return FutureBuilder(
      future: getUserDetails(widget.users, widget.currentUser),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          //return Container(child: Ctext("getting user"),);
        }

        if (snapshot.hasError) {
          return Container(
            child: Ctext("Error getting user"),
          );
        }

        if (snapshot.hasData) {
          var data = snapshot.data as Map<String, dynamic>;

          return buildChatUser(data);
        }

        return Container();
      },
    );
  }

  getUserDetails(Map<String, dynamic> map, String currentUser) async {
    Map<String, dynamic>? chat_details;

    for (String key in map.keys) {
      if (key != currentUser) {
        await FirebaseFirestore.instance
            .collection("users")
            .where('uid', isEqualTo: key)
            .limit(1)
            .get()
            .then((value) async {
          chat_details = {
            "name": value.docs[0].data()['name'],
            "friendUid": key,
            "image": value.docs[0].data()['image']
          };
        });
      }
    }

    return chat_details;
  }

  buildChatUser(dynamic user_details) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _callChatScreen(context,
            user_details['name'], user_details['friendUid']),
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
                      AssetImage("assets/${user_details['image']}"),
                  //maxRadius: 30,
                  radius: 30.0,
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(user_details['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0,
                                    color: themeProvider.getTheme == Themes.darkTheme ? Colors.white : Palette.primaryTextColor
                                )),
                                Ctext(dateToString(widget.timestamp), size: 13.0, color: Colors.grey)

                          ]),
                      getStreamBuilder()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getStreamBuilder() {
    int unreadCount = 0;

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("chats").doc(widget.friendDoc).collection("messages")
            //.where("read", isEqualTo: false)
           // .where("uid", isNotEqualTo: currentUser)
            .orderBy("createdOn", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            log("Snapshot has error");
            return Center(
              child: Text("Something went wrong"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            //return Center (child: Text("Loading..."),);
          }

          if (snapshot.hasData) {
            unreadCount = 0;
            if (snapshot.data!.size > 0) {

              for(int i = 0; i<snapshot.data!.size; i++){
                var msg = snapshot.data!.docs[i];
                if(msg['read'] == false && msg['uid'] != currentUser){
                  msg['msg'];
                  unreadCount +=1;
                }
              }
              var data = snapshot.data!.docs[0];

            // lastDate = data['createdOn'] != null ? dateToString(data['createdOn'].toDate()) : dateToString(DateTime.now());
              return Container(
                //color: Colors.black,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    SizedBox(height: 5.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            //padding: EdgeInsets.only(right: 5.0),
                            child: Ctext(data['msg'].toString(),
                                size: 13.0, color: Colors.grey)),
                       unreadCount > 0 ? Container(
                          height: 20.0,
                          width: 20.0,
                          //padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: Palette.primaryColor,
                              shape: BoxShape.circle),
                          child: Center(
                              child: Ctext(
                            "$unreadCount",
                            size: 11.0,
                          )),
                        ) : Container(height: 20.0, width: 20.0,)
                      ],
                    ),
                  ],
                ),
              );
/*
              ChatUsersList(
              onTap: () => _callChatScreen(context, data['name'], data['uid']),
              text: "New Message",
              secondaryText: data['msg'],
              image: "assets/whatsapp-logo.png",
              isMessageRead: true,
              time: dateToString(data['createdOn'].toDate()),); */
            }
          }
          return Container();
        });
  }
}
