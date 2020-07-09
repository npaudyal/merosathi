
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/modals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merosathi/models/user.dart';
import 'package:merosathi/services/database.dart';
import 'package:merosathi/ui/pages/conversation_screen.dart';
import 'package:merosathi/ui/pages/heart.dart';
import 'package:merosathi/ui/pages/my_profile.dart';
import 'package:merosathi/ui/pages/search.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:merosathi/ui/widgets/animations/slide_tansition.dart';

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
    MenuItem(x: -1.0, name: 'lak', color: Colors.red),
    MenuItem(x: -0.3, name: 'message', color: Colors.purple),
   
    MenuItem(x: 0.3, name: 'heart', color: Colors.pink),
    MenuItem(x: 1.0, name: 'head', color: Colors.yellow),
  ];

  MenuItem active;
  
 
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomStream;

List filter = [];
List filtered = [];

  

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return snapshot.hasData? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {

            filter.add(ChatRoomTile(
                snapshot.data.documents[index].data['name'],
                snapshot.data.documents[index].data['chatRoomId'],
                widget.currentUser,
                
                snapshot.data.documents[index].data['photoUrl'],
                snapshot.data.documents[index].data['uid'],

              ));

              filtered = filter;
              
            return  FocusedMenuHolder(
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
             onPressed: () {
              
              databaseMethods.deleteMessages(snapshot.data.documents[index].data['chatRoomId']);
             },

             trailingIcon: Icon(Icons.delete),
              backgroundColor: Colors.redAccent
             ),
          ],
           
              child: filtered[index]
            );

          }
          ): Container();
      }
        );
      }

  // void _filter(value) {

  //   filter.where((element) => false)
  // }
      



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
                            Icon(FontAwesomeIcons.heart,color: Colors.pink,size: 20,),
                            SizedBox(width: 2,),
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
         Navigator.push(context, SlideRightRoute(
           page: MyProfile(currentUserId: widget.userId, currentUser: currentUser, userId: widget.userId)));
        }
        if(item.name == "heart") {
          Navigator.push(context, SlideRightRoute(page: Heart(userId: widget.userId,currentUserId: widget.userId, currentUser: currentUser, )));//Matches(userId: widget.userId,)));
        }
        if(item.name == "lak"){
        Navigator.push(context, SlideRightRoute(page: Search(userId: widget.userId)));

        }
      },
    );
  }
}

class ChatRoomTile extends StatefulWidget {
  final String userName;
  final String chatRoomId;
  final User currentUser;
  final String userId;
  final String photoUrl;
  ChatRoomTile(this.userName, this.chatRoomId, this.currentUser, this.photoUrl, this.userId);

  @override
  _ChatRoomTileState createState() => _ChatRoomTileState();
}

class _ChatRoomTileState extends State<ChatRoomTile> {

  
  @override
  Widget build(BuildContext context) {
     return  GestureDetector(
          
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => ConversationScreen(chatRoomId:widget.chatRoomId, currentUser: widget.currentUser, userName: widget.userName, photoUrl: widget.photoUrl,userId: widget.userId, )));
          },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal:24, vertical :12),
          child: Row(
            children: <Widget>[
               CircleAvatar(
                      backgroundImage: NetworkImage(widget.photoUrl),
                      maxRadius: 30,
                    ),
                    SizedBox(width: 16,),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(widget.userName),
                            SizedBox(height: 6,),
                            Text("Active now",style: TextStyle(fontSize: 14,color: Colors.grey.shade500),),
                          ],
                        ),
                      ),
                    ),
                  ],
             
          ),
          
        ),
      //),
    );
  }
}