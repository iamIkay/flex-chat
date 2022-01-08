import 'dart:developer';

import 'package:chat_app/login/user_name.dart';
import 'package:chat_app/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../custom_text.dart';

enum Status { Waiting, Error }

class VerifyNumber extends StatefulWidget {
  const VerifyNumber({Key? key, this.number}) : super(key: key);
  final number;
  @override
  _VerifyNumberState createState() => _VerifyNumberState(number);
}

class _VerifyNumberState extends State<VerifyNumber> {
  final phoneNumber;
  var _status = Status.Waiting;
  var _verificationId;
  var _textEditingController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  _VerifyNumberState(this.phoneNumber);

  @override
  void initState() {
    super.initState();
    _verifyPhoneNumber();
  }

  Future _verifyPhoneNumber() async {
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phonesAuthCredentials) async {},
        verificationFailed: (verificationFailed) async {
          log("Verification failed! ${verificationFailed.message}");
        },
        codeSent: (verificationId, resendingToken) async {
          setState(() {
            this._verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (verificationId) async {});
  }

  Future _sendCodeToFirebase({String? code}) async {
    if (this._verificationId != null) {
      var credential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: code!);

      await _auth
          .signInWithCredential(credential)
          .then((value) {
        Navigator.push(
            context, CupertinoPageRoute(builder: (context) => Username()));
      })
          .whenComplete(() {})
          .onError((error, stackTrace) {
        setState(() {
          print(error);
          _textEditingController.text = "";
          this._status = Status.Error;
        });
      });
    }
    else{
      log("Verification ID is Null !!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Ctext("Verify Number"),
        previousPageTitle: "Edit Number",
      ),
      child: _status != Status.Error
          ? Padding(
            padding: const EdgeInsets.only(right: 30.0, left: 30.0),
            child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0, top: 120.0),
            child: Image.asset("assets/logo_icon.png", scale: 3,),
          ),

          Ctext("We sent you",
            size: 25.0, weight: FontWeight.w500,),

          Ctext("an SMS code",
            size: 25.0, weight: FontWeight.w500,),

            SizedBox(height: 20.0),

            Ctext(phoneNumber == null ? "" : "Enter OTP sent to: $phoneNumber", color: CupertinoColors.secondaryLabel,),

          SizedBox(height: 20.0),

          CupertinoTextField(
                onChanged: (value) async {
                  if (value.length == 6) {
                    //perform the auth verification
                    _sendCodeToFirebase(code: value);
                  }
                },
                textAlign: TextAlign.center,
                style: TextStyle(letterSpacing: 30, fontSize: 30),
                maxLength: 6,
                controller: _textEditingController,
                keyboardType: TextInputType.number),

          SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Didn't receive the OTP?"),
                CupertinoButton(
                    child: Text("RESEND OTP"),
                    onPressed: () async {
                      setState(() {
                        this._status = Status.Waiting;
                      });
                      _verifyPhoneNumber();
                    })
              ],
            )
        ],
      ),
          )
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text("OTP Verification",
                style: TextStyle(
                    color: Palette.primaryColor.withOpacity(0.7),
                    fontSize: 30)),
          ),
          Text("The code used is invalid!"),
          CupertinoButton(
              child: Text("Edit Number"),
              onPressed: () => Navigator.pop(context)),
          CupertinoButton(
              child: Text("Resend Code"),
              onPressed: () async {
                setState(() {
                  this._status = Status.Waiting;
                });

                _verifyPhoneNumber();
              }),
        ],
      ),
    );
  }
}