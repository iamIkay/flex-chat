import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ChatMessage{
  String message;
  String uid;
  Timestamp? time;
  bool? isRead;
  MessageType type;

  ChatMessage({required this.message, required this.uid, required this.time, this.isRead, required this.type});
}

enum MessageType{
  text,
  image,

}