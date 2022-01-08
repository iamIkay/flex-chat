import 'dart:io';

import 'package:chat_app/home.dart';
import 'package:chat_app/login/hello.dart';
import 'package:chat_app/palette.dart';
import 'package:chat_app/preferences/user_preferences.dart';
import 'package:chat_app/providers/theme_provider.dart';
import 'package:chat_app/providers/utility_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


const bool USE_EMULATOR = true;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if(USE_EMULATOR){
    _connectToFirebaseEmulator();
  }
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<UtilityProvider>(create: (_) => UtilityProvider()),
    ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider())
  ], child: MyApp()));
}

Future _connectToFirebaseEmulator() async{
  final firestorePort = "";
  final authPort = "xxxx";
  final storagePort = "xxxx";
  final localHost = Platform.isAndroid ? '10.0.2.2': 'localhost';

  FirebaseFirestore.instance.settings = Settings(
    host: "$localHost:$firestorePort",
    sslEnabled: false,
    persistenceEnabled: false
  );

  await FirebaseAuth.instance.useAuthEmulator(localHost, authPort);

  await FirebaseStorage.instance.useStorageEmulator(localHost, storagePort);

}

UserPreference preference = UserPreference(Brightness.light, Palette.primaryTextColor);
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
  

    final themeProvider = Provider.of<ThemeProvider>(context);
    return CupertinoApp(
          title: 'Flex Chat',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.getTheme,
      home: HelloScreen()
    );
  }
}

