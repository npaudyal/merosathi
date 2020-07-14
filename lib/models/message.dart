import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {

  String senderName, senderId, selectedUserId, text, photoUrl;
  File photo;
  Timestamp timestamp;

  Message({
    this.senderName,
    this.senderId,
    this.selectedUserId,
    this.text,
    this.photo,
    this.photoUrl,
    this.timestamp
  });

  
   


}