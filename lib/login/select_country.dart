import 'dart:convert';

import 'package:chat_app/custom_text.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

class SelectCountry extends StatefulWidget {
  const SelectCountry({Key? key}) : super(key: key);

  @override
  _SelectCountryState createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {

  List<dynamic>? dataRetrieved;
  List<dynamic>? data;

  var _searchController = TextEditingController();
  var searchValue = "";

  @override
  void initState() {
    // TODO: implement initState
    _getData();

  }

  _getData() async{
    final String response = await rootBundle.loadString("assets/CountryCodes.json");
    dataRetrieved = await json.decode(response) as List<dynamic>;

    setState(() {
      data = dataRetrieved;
    });

  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
           CupertinoSliverNavigationBar(
             largeTitle: Ctext("Select Country", size: 25.0, weight: FontWeight.bold,),
             previousPageTitle: "Sign up",
           ),

          SliverToBoxAdapter(
            child: CupertinoSearchTextField(
              onChanged: (value){
                setState(() {
                  searchValue = value;
                });

              },
              controller: _searchController,
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate((data != null) ? data! .where((e) => e['name'].toString().toLowerCase().contains(searchValue)) .map((e) => CupertinoListTile(
                onTap: () => Navigator.pop(context, {"name": e["code"], "code": e["dial_code"].toString()}),
                title: Ctext(e['name']),
                trailing: Ctext(e['dial_code']),
              )).toList()
          : [
            Center(child: Ctext("Loading"))]

          ))
        ],


      )
    );
  }
}
