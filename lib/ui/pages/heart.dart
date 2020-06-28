import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merosathi/models/user.dart';
import 'package:merosathi/ui/pages/matchTab.dart';
import 'package:merosathi/ui/pages/likesTab.dart';
import 'package:merosathi/ui/pages/my_profile.dart';
import 'package:merosathi/ui/pages/search.dart';

class MenuItem {
  final String name;
  final Color color;
  final double x;
  MenuItem({this.name, this.color, this.x});
}

class Heart extends StatefulWidget {

  final String userId;
  final User currentUser;
  final String currentUserId;

   Heart({this.userId, this.currentUser, this.currentUserId});
  @override
  _HeartState createState() => _HeartState();
}

class _HeartState extends State<Heart> {

 List<Container> feed = [];
   List items = [
    MenuItem(x: -1.0, name: 'search_to_close', color: Colors.red),
    MenuItem(x: -0.3, name: 'message', color: Colors.purple),
   
    MenuItem(x: 0.3, name: 'heart', color: Colors.pink),
    MenuItem(x: 1.0, name: 'head', color: Colors.yellow),
  ];

  MenuItem active;

  @override
  void initState() {
    active = items[2];
    super.initState();
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
           builder: (context) => MyProfile(userId: widget.userId, currentUserId: widget.currentUserId, currentUser: currentUser,)));
        }
         if(item.name == "search_to_close"){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>Search(userId: widget.userId)));

        }
        
        if(item.name =="message") {

        }
      },
    );

  }


  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
     MatchTab(userId: widget.userId,),
     LikesTab(userId: widget.userId,)

    // Likes()
  ];
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
       child: Scaffold(
         appBar: PreferredSize(
         preferredSize: MediaQuery.of(context).size/10,
         child: AppBar(
             
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            unselectedLabelColor: Colors.deepPurple,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.deepPurple, Colors.green]),
              borderRadius: BorderRadius.circular(50),
             color: Colors.deepPurple,
            ),
               tabs: [
                 Tab(
                   child: Align(
                     alignment: Alignment.center,
                     child: Text("Matches", style: GoogleFonts.roboto(fontSize:size.width*0.04),
                     ),
                   ),

                 ),
                 Tab(
                   child: Align(
                     alignment: Alignment.center,
                     child: Text("Likes", style: GoogleFonts.roboto(fontSize:size.width*0.04),),
                   ),

                 ),


               ],),
           ),
         ),

         body: TabBarView(
            children: pages),

       bottomNavigationBar:Container(
      
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
    ),

       ),

       )
       
       ;
  }
}