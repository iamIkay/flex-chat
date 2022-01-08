import 'package:chat_app/custom_text.dart';
import 'package:chat_app/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: (){},
        child: Text("Terms and conditions", style: TextStyle(fontSize: 13.0, color: CupertinoColors.secondaryLabel, decoration: TextDecoration.underline)));
  }
}
