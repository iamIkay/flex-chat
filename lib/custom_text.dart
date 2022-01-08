import 'package:chat_app/palette.dart';
import 'package:flutter/material.dart';

class Ctext extends StatelessWidget {
  final String text;
  final dynamic size;
  final  Color? color;
  final FontWeight? weight;
  final TextAlign align;

  const Ctext(this.text, {this.align = TextAlign.left, this.color, this.size, this.weight = FontWeight.normal, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: size, fontWeight: weight, color: color?? Palette.primaryTextColor),
      textDirection: TextDirection.ltr,
      textAlign: align,
    );
  }
}