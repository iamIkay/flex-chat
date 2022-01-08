import 'dart:ui';

import 'package:chat_app/custom_text.dart';
import 'package:chat_app/login/get_started.dart';
import 'package:chat_app/login/terms_and_conditions.dart';
import 'package:flutter/material.dart';

import '../palette.dart';
import 'logo.dart';

class HelloScreen extends StatefulWidget {
  const HelloScreen({Key? key}) : super(key: key);

  @override
  State<HelloScreen> createState() => _HelloScreenState();
}

class _HelloScreenState extends State<HelloScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(

       color: Colors.white
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5) ,
        child: Container(
          color: Palette.primaryColor.withOpacity(0.1),
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                //color: Colors.green,
                height: MediaQuery.of(context).size.height/ 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset("assets/logo.png", scale: 3),

                    SizedBox(height: 30),

                    Ctext("Chat with friends all over the world", align: TextAlign.center, size: 18.0,),

                  ],
                ),
              ),

              Container(

                height: MediaQuery.of(context).size.height/ 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GetStarted(),

                    SizedBox(height: 80),

                    TermsAndConditions(),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
