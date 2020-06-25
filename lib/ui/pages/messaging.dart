import 'package:flutter/material.dart';
import 'package:merosathi/models/user.dart';

class MessagePage extends StatefulWidget {

  final User currentUser, selectedUser;

  MessagePage({this.currentUser, this.selectedUser});
   
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}