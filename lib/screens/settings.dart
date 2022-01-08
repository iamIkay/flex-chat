import 'dart:developer';

import 'package:chat_app/custom_text.dart';
import 'package:chat_app/palette.dart';
import 'package:chat_app/providers/theme_provider.dart';
import 'package:chat_app/themes/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

var themeProvider;
FirebaseFirestore firestore = FirebaseFirestore.instance;
var currentUser = FirebaseAuth.instance.currentUser!.uid;
class _SettingsScreenState extends State<SettingsScreen> {
  bool notifValue = true;
  bool readValue = true;
  bool darkValue = false;

  @override
  Widget build(BuildContext context) {

   themeProvider = Provider.of<ThemeProvider>(context);

    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection("users")
        .where('uid', isEqualTo: currentUser)
      .limit(1)
        .snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return Center(
            child: Text("Error fetching data"),
          );
        }

        if(snapshot.connectionState == ConnectionState.waiting){
          //return
        }

        if(snapshot.hasData) {
          var data = snapshot.data!.docs.single;
          return SafeArea(
            top: false,
            child: CustomScrollView(
              slivers: [
                CupertinoSliverNavigationBar(
                  largeTitle: Text(
                    "Settings", style: TextStyle(fontSize: 26.0),),
                  automaticallyImplyLeading: false,
                  //backgroundColor: Colors.white,
                  //backgroundColor: themeProvider.getTheme == Themes.lightTheme ? Palette.primaryColor : null
                ),

                SliverList(delegate: SliverChildListDelegate(
                    [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 10.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: themeProvider.getTheme == Themes.darkTheme ? Colors.black : Colors.white,
                                  backgroundImage: AssetImage(
                                    "assets/${data['image']}"),
                                  radius: 35.0,
                                ),

                                SizedBox(width: 20.0,),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data['name'], style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),),

                                    Text(data['status'],
                                        style: TextStyle(fontSize: 13.0, color: Colors.grey))
                                  ],
                                )
                              ],
                            ),
                          ),

                          Divider(color: Colors.grey,),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0),
                            child: Column(
                              children: [
                                GenerateRow(
                                    CupertinoIcons.forward, "Edit profile"),

                                GenerateRow(
                                    CupertinoIcons.forward, "Change password"),

                                GenerateRow(CupertinoIcons.forward, "Chats"),

                                buildSwitchRow(
                                    "Notification", buildNotifSwitch()),
                                buildSwitchRow(
                                    "Read receipts", buildReadSwitch()),
                                buildSwitchRow("Night mode", buildDarkSwitch()),

                                GenerateRow(
                                    CupertinoIcons.forward, "Help and support"),
                                GenerateRow(CupertinoIcons.forward,
                                    "Terms and conditions")
                              ],
                            ),
                          )

                        ],
                      ),
                    ]
                ))
              ],


            ),
          );
        }
        return Container();
      }
    );
  }


  Widget buildNotifSwitch() => Switch.adaptive(
     activeColor: Palette.primaryColor,
      value: notifValue, onChanged: (value) => setState(() {
    notifValue = value;
  })
  );

  Widget buildReadSwitch() => Switch.adaptive(
    activeColor: Palette.primaryColor,
      value: readValue, onChanged: (value) => setState(() {
    readValue = value;
  })
  );

  Widget buildDarkSwitch() => Switch.adaptive(
      activeColor: Palette.primaryColor,
      value: darkValue, onChanged: (value) => setState(() {
    darkValue = value;
    themeProvider.toggleTheme();
  })
  );


  GenerateRow(IconData icon, String s) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(s),

          Icon(icon, size: 18, color: Colors.grey,),

        ],
      ),
    );
  }

  buildSwitchRow(String s, var buildSwitch) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(s),

          buildSwitch
        ],
      ),
    );
  }
}

