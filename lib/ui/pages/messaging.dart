import 'dart:async';
import 'dart:io';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merosathi/bloc/messaging/messaging_bloc.dart';
import 'package:merosathi/bloc/messaging/messaging_event.dart';
import 'package:merosathi/bloc/messaging/messaging_state.dart';
import 'package:merosathi/models/message.dart';
import 'package:merosathi/models/user.dart';
import 'package:merosathi/repositories/messageRepository.dart';
import 'package:merosathi/repositories/messaging.dart';
import 'package:merosathi/services/database.dart';
import 'package:merosathi/ui/pages/people_profile.dart';
import 'package:merosathi/ui/widgets/message.dart';
import 'package:merosathi/ui/widgets/photo.dart';

class Messaging extends StatefulWidget {
  final User currentUser, selectedUser;

  const Messaging({this.currentUser, this.selectedUser});

  @override
  _MessagingState createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  TextEditingController _messageTextController = TextEditingController();
  MessagingRepository _messagingRepository = MessagingRepository();
  MessagingBloc _messagingBloc;
  bool isValid = false;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  MessageRepository _messageRepository = MessageRepository();


  @override
  void initState() {
    super.initState();
    checkIfBlocked();
    _messagingBloc = MessagingBloc(messagingRepository: _messagingRepository);

    _messageTextController.text = '';
    _messageTextController.addListener(() {
      setState(() {
        isValid = (_messageTextController.text.isEmpty) ? false : true;
      });
    });
  }

  @override
  void dispose() {
    _messageTextController.dispose();
    super.dispose();
  }

  void _onFormSubmitted() {
    print("Message Submitted");

    _messagingBloc.add(
      SendMessageEvent(
        message: Message(
          text: _messageTextController.text,
          senderId: widget.currentUser.uid,
          senderName: widget.currentUser.name,
          selectedUserId: widget.selectedUser.uid,
          photo: null,
        ),
      ),
    );
    _messageTextController.clear();
  }

  bool isBlocked = false;

 checkIfBlocked() async {
   DocumentSnapshot ds = await Firestore.instance.collection("users").document(widget.currentUser.uid)
   .collection("blocked").document(widget.selectedUser.uid)
   .get();
   this.setState(() { 

     isBlocked = ds.exists;

   });

 }

  @override
  Widget build(BuildContext context) {
     //final _scrollController = ScrollController();
    Size size = MediaQuery.of(context).size;

    return Scaffold(

      appBar: AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Container(
          padding: EdgeInsets.only(right: 5),
          height: MediaQuery.of(context).size.height,
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back,color: Colors.black,),
              ),
              SizedBox(width: 2,),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PeopleProfile(user:widget.selectedUser, currentUser: widget.currentUser, currentUserId: widget.currentUser.uid,)));
                  },
                  child:  CachedNetworkImage(imageUrl: widget.selectedUser.photo,
              imageBuilder: (context,imageProvider) => CircleAvatar(
                
                backgroundImage: imageProvider,
                maxRadius: 20,
              ),            
            )
              ),
              SizedBox(width: 12,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(widget.selectedUser.name,style: TextStyle(fontWeight: FontWeight.w600),),
                    SizedBox(height: 3,),
                    Text("Active",style: TextStyle(color: Colors.green,fontSize: 12),),
                  ],
                ),
              ),
              

              !isBlocked ?GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                       builder: (_) => CupertinoAlertDialog(
                         
                       content: Wrap(
                         
                         children: <Widget>[
                           GestureDetector(
                             onTap: () {

                             },

                             child: Center(child: Text("Block?", style: GoogleFonts.ubuntu(color: Colors.black),)),
                           )
                         ],
                       ),
                       actions: <Widget>[
                         FlatButton(
                           
                           onPressed: () {

                              databaseMethods.blockUsers(widget.selectedUser.uid, widget.currentUser.uid);
                              //_messageRepository.deleteChat(currentUserId: widget.currentUser.uid, selectedUserId:widget.selectedUser.uid);
                             Navigator.of(context, rootNavigator: true).pop('dialog');
                             Navigator.pop(context);

                           },
                           child: Text("Yes", style: GoogleFonts.ubuntu(color: Colors.red),)),
                           FlatButton(onPressed: () {



                             Navigator.of(context, rootNavigator: true).pop('dialog');
                           },
                            child: Text("No", style: GoogleFonts.ubuntu(color: Colors.green),)
                            
                            )
                         
                       ],
                     ),
                  );

                },
                child: Icon(Icons.more_vert, color: Colors.black,),
              ): Text(""),
            ],
        ),
        ),
      ),
      ),
   
      body: BlocBuilder<MessagingBloc, MessagingState>(
        bloc: _messagingBloc,
        builder: (BuildContext context, MessagingState state) {
          if (state is MessagingInitialState) {
            _messagingBloc.add(
              MessageStreamEvent(
                  currentUserId: widget.currentUser.uid,
                  selectedUserId: widget.selectedUser.uid),
            );
          }
          if (state is MessagingLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is MessagingLoadedState) {
            Stream<QuerySnapshot> messageStream = state.messageStream;
            return !isBlocked ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                  stream: messageStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text(
                          "Start the conversation?",
                          style: GoogleFonts.ubuntu(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                    if (snapshot.data.documents.isNotEmpty) {
                      return Expanded(
                        child: Column(
                          children: <Widget>[
                           
                            Expanded(

                              child: ListView.builder(
                                shrinkWrap: true,
                                //controller: _scrollController,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  return MessageWidget(
                                    currentUserId: widget.currentUser.uid,
                                    messageId: snapshot
                                        .data.documents[index].documentID,
                                  );
                                },
                                itemCount: snapshot.data.documents.length,
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          "Start the conversation ?",
                          style: GoogleFonts.ubuntu(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                  },
                ),
                Container(
                  width: size.width,
                  height: size.height * 0.08,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          File photo =
                              await FilePicker.getFile(type: FileType.image);
                          if (photo != null) {
                            _messagingBloc.add(
                              SendMessageEvent(
                                message: Message(
                                    text: null,
                                    senderName: widget.currentUser.name,
                                    senderId: widget.currentUser.uid,
                                    photo: photo,
                                    selectedUserId: widget.selectedUser.uid),
                              ),
                            );
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.height * 0.009),
                          child: Icon(
                            Icons.add,
                            color: Colors.black,
                            size: size.height * 0.04,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: size.height * 0.07,
                          padding: EdgeInsets.all(size.height * 0.01),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(size.height * 0.04),
                          ),
                          child: Center(
                            child: TextField(
                              
                              controller: _messageTextController,
                              
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                
                                hintText: "Type your message..."
                              ),
                            
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: isValid ? _onFormSubmitted : null,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.height * 0.01),
                          child: Icon(
                            Icons.send,
                            size: size.height * 0.04,
                            color: isValid ? Colors.black : Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ): Center(child: Text("You can no longer continue the conversation!"),);
          }
          return Container();
        },
      ),
    );
  }
}