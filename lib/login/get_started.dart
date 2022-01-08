import 'package:chat_app/login/register_number.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../palette.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      //height: 50,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), border: Border.all(width: 1.0, color: Palette.primaryColor)),
      child: CupertinoButton(
          onPressed: (){
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => const RegisterNumber())
      );},
          child:  const Text("Get Started", style: TextStyle(fontSize: 20.0)),

    ),
    );
  }
}
