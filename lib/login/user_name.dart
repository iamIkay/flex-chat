import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../home.dart';

class Username extends StatelessWidget {
  Username({Key? key}) : super(key: key);
  var _text = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection("users");

  _uploadUserDoc(){
    User? user = FirebaseAuth.instance.currentUser;
    var uid = user!.uid;

    users.where('uid', isEqualTo: uid)
    .limit(1)
    .get()
    .then((value) {
      if(value.docs.isEmpty){
        users.add({
          'name': _text.text,
          'phone': user.phoneNumber,
          'status': "Available",
          'uid': uid.toString(),
          'friends': [uid.toString()],
          'image': "avater.png"
        }
        );
      }
    })
    .onError((error, stackTrace) {
      Fluttertoast.showToast(msg: error.toString());
    });
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 150.0, bottom: 60.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(
                "assets/avater.png"),
              radius: 60.0,
            ),
          ),
          Text("Enter your name",),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 55),
            child: CupertinoTextField(
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
              maxLength: 15,
              controller: _text,
              keyboardType: TextInputType.name,
              autofillHints: <String>[AutofillHints.name],
            ),
          ),
          CupertinoButton.filled(
              child: Text("Continue"),
              onPressed: () {
                FirebaseAuth.instance.currentUser!
                    .updateDisplayName(_text.text);

                _uploadUserDoc();

                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => Home()));
              })
        ],
      ),
    );
  }
}
