import 'dart:developer';

import 'package:chat_app/palette.dart';
import 'package:chat_app/providers/theme_provider.dart';
import 'package:chat_app/screens/people.dart';
import 'package:chat_app/themes/themes.dart';
import 'package:chat_app/widgets/chat.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:chat_app/widgets/chat_list_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../chat_detail.dart';
import '../custom_text.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  _callChatScreen(BuildContext context, String username, String uid) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) =>
                ChatDetail(friendUid: uid, friendName: username)));
  }

  var _searchController = TextEditingController();

 bool _isSearchbarVisible = false;
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .where('userslist', arrayContains: currentUser)
            .orderBy('last_updated', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            log("An error occured");
            return Center(
              child: Text("Something went wrong"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {}

          if (snapshot.hasData) {
            if(snapshot.data!.size == 0){
              return SafeArea(
                top: false,
                child: CustomScrollView(slivers: [
                  CupertinoSliverNavigationBar(
                      largeTitle: Text("Chats", style: TextStyle(fontSize: 28.0)),
                      automaticallyImplyLeading: false,
                      trailing: Material(
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                              IconButton(
                                  icon: Icon(Icons.search, color: themeProvider.getTheme == Themes.darkTheme ? Colors.grey : Colors.black.withOpacity(0.7)),
                                  onPressed: ()=> setState(() {
                                 _isSearchbarVisible = !_isSearchbarVisible;
                                  })),

                              IconButton(
                                  icon: Icon(Icons.more_vert, color: themeProvider.getTheme == Themes.darkTheme ? Colors.grey : Colors.black.withOpacity(0.7)),
                                  onPressed: (){}),
                            ],
                          ))
                  ),
                  SliverToBoxAdapter(
                    child: Material(
                      color: Colors.transparent,
                      child: Visibility(
                        visible: _isSearchbarVisible,
                        child: CupertinoSearchTextField(
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(12.0),),

                          onChanged: (value){
                            setState(() {
                              //searchValue = value;
                            });

                          },
                          controller: _searchController,
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                      delegate:  emptyScreen(context))
                ]),
              );
            }

            return SafeArea(
              top: false,
              child: CustomScrollView(slivers: [
                CupertinoSliverNavigationBar(
                  largeTitle: Text("Chats", style: TextStyle(fontSize: 28.0)),
                  automaticallyImplyLeading: false,
                    trailing: Material(
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            IconButton(
                                icon: Icon(Icons.search, color: themeProvider.getTheme == Themes.darkTheme ? Colors.grey : Colors.black.withOpacity(0.7)),
                                onPressed: ()=> setState(() {
                                  _isSearchbarVisible = !_isSearchbarVisible;
                                })),

                            IconButton(
                                icon: Icon(Icons.more_vert, color: themeProvider.getTheme == Themes.darkTheme ? Colors.grey : Colors.black.withOpacity(0.7)
                                ),
                                onPressed: (){}),
                          ],
                        ))
                ),
                SliverToBoxAdapter(
                  child: Material(
                    color: Colors.transparent,
                    child: Visibility(
                      visible: _isSearchbarVisible,
                      child: CupertinoSearchTextField(
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(12.0)),
                        onChanged: (value){
                          setState(() {
                            //searchValue = value;
                          });

                        },
                        controller: _searchController,
                      ),
                    ),
                  ),
                ),
                SliverList(
                    delegate: loadChats(snapshot))
              ]),
            );
          }

          return Container();
        });
  }

  SliverChildListDelegate loadChats(AsyncSnapshot<QuerySnapshot> snapshot){
    return SliverChildListDelegate(
        snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data =
          document.data()! as Map<String, dynamic>;

          bool messages = false;

          return StreamBuilder<QuerySnapshot>(
              stream: chats
                  .doc(document.id)
                  .collection("messages")
                  .snapshots(),
              builder: (context, snapshot) {

                if(snapshot.connectionState == ConnectionState.waiting){
                  //return Container();
                }

                if(snapshot.hasError){
                  return Container();
                }

                if(snapshot.hasData) {
                  if (snapshot.data!.size > 0) {
                    return ChatUser(
                      currentUser: currentUser,
                      users: data['users'],
                      timestamp: data['last_updated'] == null ? DateTime.now() : data['last_updated'].toDate(),
                      friendDoc: document.id.toString(),
                    );
                  }

                }

                return Container();
              }
          );

        }).toList());
  }

  SliverChildListDelegate emptyScreen(BuildContext context){
    return SliverChildListDelegate([
      Container(
          height:
          MediaQuery.of(context).size.height / 2,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Welcome to ",
                      style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold)),
                  Text("Flex Chat!",
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Palette.primaryColor,

                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text("Your chat list is empty"),
              ),
              Row(
                children: [
                  Text(
                    "Go to ",
                  ),
                  Text("Contacts ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Palette.primaryColor)),
                  Text(
                    "to start a conversation",
                  ),
                ],
              ),
            ],
          ))
    ]);
  }

  showName(Map<String, dynamic> map, String currentUser) async {
    String? name;
    for (String key in map.keys) {
      if (key != currentUser) {
        log("Other user: $key");

        await FirebaseFirestore.instance
            .collection("users")
            .where('uid', isEqualTo: key)
            .limit(1)
            .get()
            .then((value) async {
          name = await value.docs[0].data()['name'].toString();

          log("I got the name as: $name");
        });

        return name;
      }
    }
  }
}