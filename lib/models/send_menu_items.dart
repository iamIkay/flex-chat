import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SendMenuItems{
  String text;
  IconData icons;
  MaterialColor color;
  FileType fileType;
  SendMenuItems({required this.text, required this.icons, required this.color, required this.fileType});
}