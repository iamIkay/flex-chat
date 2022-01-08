import 'package:flutter/material.dart';

Widget logo(var width, var height){
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(39.0),
        color: Colors.white.withOpacity(0.9)
    ),
    child: Image.asset("assets/logo.png"),
  );
}