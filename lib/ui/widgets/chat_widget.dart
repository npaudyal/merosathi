import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merosathi/models/chat.dart';
import 'package:merosathi/models/message.dart';
import 'package:merosathi/models/user.dart';
import 'package:merosathi/repositories/messageRepository.dart';
import 'package:merosathi/ui/pages/messaging.dart';
import 'package:merosathi/ui/widgets/pageTurn.dart';
import 'package:merosathi/ui/widgets/photo.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatWidget extends StatefulWidget {
  final String userId, selectedUserId;
  final Timestamp creationTime;

  const ChatWidget({this.userId, this.selectedUserId, this.creationTime});

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  MessageRepository messageRepository = MessageRepository();
  Chat chat;
  User user;

  getUserDetail() async {
    user = await messageRepository.getUserDetail(userId: widget.selectedUserId);
    Message message = await messageRepository
        .getLastMessage(
            currentUserId: widget.userId, selectedUserId: widget.selectedUserId)
        .catchError((error) {
      print(error);
    });

    if (message == null) {
      return Chat(
        name: user.name,
        photoUrl: user.photo,
        lastMessage: null,
        lastMessagePhoto: null,
        timestamp: null,
      );
    } else {
      return Chat(
        name: user.name,
        photoUrl: user.photo,
        lastMessage: message.text,
        lastMessagePhoto: message.photoUrl,
        timestamp: message.timestamp,
      );
    }
  }

  openChat() async {
    User currentUser =
        await messageRepository.getUserDetail(userId: widget.userId);
    User selectedUser =
        await messageRepository.getUserDetail(userId: widget.selectedUserId);

    try {
      pageTurn(Messaging(currentUser: currentUser, selectedUser: selectedUser),
          context);
    } catch (e) {
      print(e.toString());
    }
  }

  deleteChat() async {
    await messageRepository.deleteChat(
        currentUserId: widget.userId, selectedUserId: widget.selectedUserId);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: getUserDetail(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          Chat chat = snapshot.data;
          return
                     FocusedMenuHolder(
                                 blurSize: 4,
                                        blurBackgroundColor: Colors.white,
                                        menuWidth: MediaQuery.of(context).size.width,
                                        menuItemExtent: 50,
                                        
                                        menuBoxDecoration: BoxDecoration(
                                          color: Colors.blue,
                                          boxShadow: [BoxShadow(color:Colors.black, blurRadius:5, spreadRadius: 1)],
                                        ),
                                        onPressed: () {
                                            
                                        },
                                        menuItems: <FocusedMenuItem>[
                                          
                                          FocusedMenuItem(title: Center(child: Text("Clear messages", style: GoogleFonts.roboto(color: Colors.white),)),
                                          onPressed: () async {
                                            
                                            await deleteChat();
                                          },

                                          trailingIcon: Icon(Icons.delete),
                                            backgroundColor: Colors.redAccent
                                          ),
                                        ],
           
                      child: GestureDetector(
              onTap: () async {
                await openChat();
              },
             
              child: Padding(
                padding: EdgeInsets.all(size.height * 0.02),
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size.height * 0.04),
                    color: Colors.white10
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          ClipOval(
                            child: Container(
                              height: size.height * 0.06,
                              width: size.height * 0.06,
                              child: PhotoWidget(
                                photoLink: user.photo,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.03,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                user.name,
                                style: GoogleFonts.ubuntu(fontSize: size.height * 0.02),
                              ),
                              chat.lastMessage != null
                                  ? Text(
                                      chat.lastMessage,
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  : chat.lastMessagePhoto == null
                                      ? Text("Chat Room Open")
                                      : Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.photo,
                                              color: Colors.grey,
                                              size: size.height * 0.02,
                                            ),
                                            Text(
                                              "Photo",
                                              style: TextStyle(
                                                fontSize: size.height * 0.015,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                            ],
                          ),
                        ],
                      ),
                      chat.timestamp != null
                          ? Text(timeago.format(chat.timestamp.toDate()))
                          : Text(timeago.format(widget.creationTime.toDate()))
                    ],
                  ),
                ),
              ),
            ),
             
          );
        }
      },
    );
  }
}