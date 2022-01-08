import 'package:flutter/cupertino.dart';
import 'package:chat_app/screens/calls.dart';
import 'package:chat_app/screens/chats.dart';
import 'package:chat_app/screens/people.dart';
import 'package:chat_app/screens/settings.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [ChatScreen(), CallScreen(), PeopleScreen(), SettingsScreen()];

    return CupertinoPageScaffold(
          child: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
                items: [
                  BottomNavigationBarItem(
                      label: "Chats",
                      icon: Icon(CupertinoIcons.chat_bubble_2_fill)),

                  BottomNavigationBarItem(
                      label: "Calls",
                      icon: Icon(CupertinoIcons.phone)),
                  BottomNavigationBarItem(label: "Contacts",
                      icon: Icon(CupertinoIcons.person_2)),
                  BottomNavigationBarItem(label: "Settings",
                      icon: Icon(CupertinoIcons.settings)),
                ]
            ), tabBuilder: (BuildContext context, int index) {
            return
              screens[index];

          },

          ),
    );
  }
}
