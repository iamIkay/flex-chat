import 'package:chat_app/login/select_country.dart';
import 'package:chat_app/login/verify_number.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../custom_text.dart';
import '../palette.dart';
import 'logo.dart';

class RegisterNumber extends StatefulWidget {
  const RegisterNumber({Key? key}) : super(key: key);

  @override
  _RegisterNumberState createState() => _RegisterNumberState();
}

TextEditingController _phoneNumberController = new TextEditingController();

class _RegisterNumberState extends State<RegisterNumber> {
  Map<String, dynamic> data = {"name":"US", "code": "+1"};
  var dataResult;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Ctext("Sign up"),
            previousPageTitle: "Back",
          ),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25.0, top: 120.0),
                        child: Image.asset("assets/logo_icon.png", scale: 3,),
                      ),

                      Ctext("Enter your mobile",
                        size: 25.0, weight: FontWeight.w500,),

                      Ctext("number",
                        size: 25.0, weight: FontWeight.w500,),

                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        //color: Colors.blue,
                        child: Ctext("We will send you a verification code", size: 15.0, color: CupertinoColors.secondaryLabel,),
                      ),

                      SizedBox(height: 30,),

                      Row(
                        children: [
                          InkWell(
                            onTap: () async{
                              dataResult = await Navigator.push(context, CupertinoPageRoute(builder: (context) => SelectCountry()));

                              setState(() {
                                if(dataResult != null) data = dataResult;
                              });
                            },
                            child: Card(
                              elevation: 0.9,
                              child: Container(

                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Ctext(
                                      "${data["name"]} ",
                                      size: 18.0,
                                      color: CupertinoColors.secondaryLabel,
                                    ), Ctext(
                                      data["code"],
                                      size: 18.0,
                                      color: CupertinoColors.secondaryLabel,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              child: CupertinoTextField(
                                placeholder: "phone number",
                                controller: _phoneNumberController,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    fontSize: 20.0, color: CupertinoColors.secondaryLabel),
                              ))
                        ],
                      ),

                      Container(
                          padding: EdgeInsets.only(top: 50),
                          width: double.infinity,
                          child: CupertinoButton.filled(child: Ctext("Send OTP"), onPressed:  (){Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => VerifyNumber(
                                    number: data['code']! + _phoneNumberController.text,
                                  )));} ))
                    ],
                  ),
                ),
              ),
              /*   CupertinoListTile(
                onTap: () async{
                  dataResult = await Navigator.push(context, CupertinoPageRoute(builder: (context) => SelectCountry()));

                  setState(() {
                    if(dataResult != null) data = dataResult;
                  });
                },
                title: Ctext(
                  data["name"],
                  color: Palette.primaryColor,
                ),
              ),
*/
            ],
          )),
    );
  }
}
