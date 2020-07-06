import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merosathi/models/user.dart';
import 'package:merosathi/services/database.dart';
import 'package:merosathi/ui/pages/info_page.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final User currentUser;
  final User user; 
  final String userName;
  final String photoUrl;
  final String userId;
  final String currentUserId;
  ConversationScreen({this.chatRoomId, this.user, this.currentUser, this.userName, this.photoUrl, this.userId, this.currentUserId});
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();

  Stream chatMessageStream;

  Widget chatMessageList() {

    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return MessageTile(snapshot.data.documents[index].data['message'],
            snapshot.data.documents[index].data['sentBy'] == widget.currentUser.name
            );

          }):Container();
      });
  }


  sendMessage() {
    if(messageController.text .isNotEmpty) {
    Map<String, dynamic> messageMap = {
      "message": messageController.text,
      "sentBy": widget.currentUser.name,
      "time":DateTime.now().millisecondsSinceEpoch
    };
    databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
    messageController.text ="";
  }
  }
  @override
  void initState() { 
    databaseMethods.getConversationMessages(widget.chatRoomId)
    .then((value) {
      setState(() {
       chatMessageStream = value;

      });
    });
    super.initState();
    
  }

  Widget customAppBar(context, userId, currentUserId) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Container(
          padding: EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back,color: Colors.black,),
              ),
              SizedBox(width: 2,),
              CircleAvatar(
                backgroundImage: NetworkImage(widget.photoUrl),
                maxRadius: 20,
              ),
              SizedBox(width: 12,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(widget.userName,style: TextStyle(fontWeight: FontWeight.w600),),
                    SizedBox(height: 6,),
                    Text("Active",style: TextStyle(color: Colors.green,fontSize: 12),),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.more_vert,color: Colors.grey.shade700,),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => InfoPage(widget.userId, widget.currentUserId)));
                },
                ),
            ],
          ),
        ),
      ),
    );
  
  }

  @override
  Widget build(BuildContext context) {
    print(widget.userId);
    print(widget.currentUserId);
    return Scaffold(

      appBar: customAppBar(context, widget.userId, widget.currentUserId),
      body: Container(
        
        child: Stack(
          children: <Widget>[
            chatMessageList(),
             Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 16,bottom: 10),
              height: 80,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.add,color: Colors.white,size: 21,),
                    ),
                  ),
                  SizedBox(width: 16,),
                  Expanded(
                    child: TextField(
                       controller: messageController,
                      decoration: InputDecoration(
                        hintText: "Type message...",
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        border: InputBorder.none
                      ),
                    ),
                  ),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                                  child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [const Color(0x36FFFFFF), const Color(0x0FFFFFF)]
                                ),
                                borderRadius: BorderRadius.circular(40),
                            ),
                            padding: EdgeInsets.only(right:20, top:4, bottom: 4),
                            child: Icon(FontAwesomeIcons.solidPaperPlane),
                          ),
                ),
              
                      

                ],
              ),
              
            ),
            
          ),

            // Container(
            //   alignment: Alignment.bottomCenter,
            //   child: Container(
            //     color: Colors.white,
            //     padding: EdgeInsets.symmetric(horizontal:24, vertical:16),
            //     child: Row(
            //       children: <Widget>[
            //         Expanded(
            //           child: TextField(
            //             controller: messageController,
            //             style: TextStyle(color: Colors.white),
            //             decoration: InputDecoration(
            //               hintText: "Message...",
            //               hintStyle: TextStyle(
            //                 color: Colors.white54,
                            
            //               ),
            //               border: InputBorder.none,
            //             ),
            //           ),
            //           ),
            //           GestureDetector(
            //             onTap: () {

            //                 sendMessage();
            //             },
            //             child: Container(
            //               height: 40,
            //               width: 40,
            //               decoration: BoxDecoration(
            //                 gradient: LinearGradient(
            //                   colors: [const Color(0x36FFFFFF), const Color(0x0FFFFFF)]
            //                   ),
            //                   borderRadius: BorderRadius.circular(40),
            //               ),
            //               padding: EdgeInsets.all(12),
            //               child: Image.asset("assets/images/send.png"),
            //             ),
            //           ),
            //       ],
            //     ),
            //   ),


            
            // ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSentByMe;

  MessageTile(this.message, this.isSentByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
     padding: EdgeInsets.only(left: isSentByMe ? 0:24, right:isSentByMe ? 24:0 ),

      width: MediaQuery.of(context).size.width,
      alignment: isSentByMe ? Alignment.centerRight:Alignment.centerLeft,
      
      child: Container(
        margin: EdgeInsets.symmetric(vertical:8),
        padding: EdgeInsets.symmetric(horizontal:24, vertical:16),
      decoration: BoxDecoration(
        
        color: !isSentByMe ? Colors.white : Colors.grey.shade200 ,
        borderRadius: BorderRadius.circular(30)
         
          
      ),
      child: Text(message, style: GoogleFonts.roboto(color:Colors.black, fontSize: 17,),
      ),
      ),
    );
  }
}

