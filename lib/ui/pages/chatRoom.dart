
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merosathi/models/user.dart';
import 'package:merosathi/services/constants.dart';
import 'package:merosathi/services/database.dart';
import 'package:merosathi/services/helper_functions.dart';
import 'package:merosathi/ui/pages/conversation_screen.dart';
import 'package:merosathi/ui/pages/heart.dart';
import 'package:merosathi/ui/pages/my_profile.dart';
import 'package:merosathi/ui/pages/search.dart';

class MenuItem {
  final String name;
  final Color color;
  final double x;
  MenuItem({this.name, this.color, this.x});
}

class ChatRoom extends StatefulWidget {
  final String userId;
  final User currentUser;
  final User user;
  final String currentUserId;

  ChatRoom({this.userId, this.currentUser, this.user, this.currentUserId});
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

    List<Container> feed = [];
   List items = [
    MenuItem(x: -1.0, name: 'search_to_close', color: Colors.red),
    MenuItem(x: -0.3, name: 'message', color: Colors.purple),
   
    MenuItem(x: 0.3, name: 'heart', color: Colors.pink),
    MenuItem(x: 1.0, name: 'head', color: Colors.yellow),
  ];

  MenuItem active;
 
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return snapshot.hasData? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {

            return ChatRoomTile(
              snapshot.data.documents[index].data['name'],
              snapshot.data.documents[index].data['chatRoomId'],
              widget.currentUser,
              
              snapshot.data.documents[index].data['photoUrl'],
              widget.userId
              
              
              

            );

          }
          ): Container();
      }
        );
      }
      


  @override
  void initState() { 
        active = items[1];

    databaseMethods.getChatRooms(widget.currentUser.name).then((val) {
      setState(() {
      chatRoomStream = val;
      });
    });
    super.initState();
    
  }

  getUserInfo() async {
    databaseMethods.getChatRooms(widget.currentUser.name).then((val) {
      setState(() {
        chatRoomStream = val;
      });
    });
  }

  


 

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
      
   return Scaffold(
       bottomNavigationBar: Container(
      
      height: 50,
      width:size. width,
      color: Colors.black,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            alignment: Alignment(active.x, -1),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 8,
              width: size.width * 0.2,
              color: active.color,
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: items.map((k) {
                return _flare(k, widget.currentUser);
              }).toList(),
            ),
          )
        ],
      ),
    )
,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SizedBox(
          height: 500,
           child: Column(
             
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(left: 16,right: 16,top: 10),
                  child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Chats",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                      Container(
                        padding: EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.pink[50],
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.add,color: Colors.pink,size: 20,),
                            SizedBox(width: 2,),
                            Text("New",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
 
              
              Padding(
                padding: EdgeInsets.only(top: 16,left: 16,right: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    prefixIcon: Icon(Icons.search,color: Colors.grey.shade400,size: 20,),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: EdgeInsets.all(8),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                            color: Colors.grey.shade100
                        )
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height:500,
                  child: chatRoomList(),
                )
              )

              
 
      
             ],
              ),
        ),
      ),
   );
            
        
      
    
  }
   Widget _flare(MenuItem item, User currentUser) {
    
    return GestureDetector(
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: FlareActor(
            'assets/${item.name}.flr',
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: item.name == active.name ? 'go' : 'idle',
          ),
        ),
      ),
      onTap: () {
        setState(() {
          active = item;
        });
        if(item.name == "head") {
         Navigator.push(context, MaterialPageRoute(
           builder: (context) => MyProfile(currentUserId: widget.userId, currentUser: currentUser, userId: widget.userId)));
        }
        if(item.name == "heart") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Heart(userId: widget.userId,currentUserId: widget.userId, currentUser: currentUser, )));//Matches(userId: widget.userId,)));
        }
        if(item.name == "search_to_close"){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>Search(userId: widget.userId)));

        }
      },
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  final User currentUser;
  final String userId;
  final String photoUrl;
  ChatRoomTile(this.userName, this.chatRoomId, this.currentUser, this.photoUrl, this.userId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId:chatRoomId, currentUser: currentUser, userName: userName, photoUrl: photoUrl,userId: userId, )));
        },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal:24, vertical :12),
        child: Row(
          children: <Widget>[
             CircleAvatar(
                    backgroundImage: NetworkImage(photoUrl),
                    maxRadius: 30,
                  ),
                  SizedBox(width: 16,),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(userName),
                          SizedBox(height: 6,),
                          Text("Active now",style: TextStyle(fontSize: 14,color: Colors.grey.shade500),),
                        ],
                      ),
                    ),
                  ),
                ],
            // Container(
            //   height: 40,
            //   width: 40,
            //   alignment:Alignment.center ,
            //   decoration: BoxDecoration(
            //     color: Colors.blue,
            //     borderRadius: BorderRadius.circular(40),
            //   ),
            //   child: CircleAvatar(
            //     backgroundImage: NetworkImage(photoUrl),
            //   ),
            // ),
            // SizedBox(width:8,),
            // Text(userName, style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w400),),
          
        ),
        
      ),
    );
  }
}