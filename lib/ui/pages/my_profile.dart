import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merosathi/bloc/authentication/bloc.dart';
import 'package:merosathi/models/user.dart';
import 'package:merosathi/ui/pages/chatRoom.dart';
import 'package:merosathi/ui/pages/heart.dart';
import 'package:merosathi/ui/pages/map.dart';
import 'package:merosathi/ui/pages/search.dart';
import 'package:merosathi/ui/pages/edit_profile.dart';
import 'package:merosathi/ui/widgets/animations/slide_tansition.dart';


Color mainColor = Color(0xff774a63);
Color secondColor = Color(0xffd6a5c0);
Color backgroundColor = Color(0xfffcf1f2);

class MenuItem {
  final String name;
  final Color color;
  final double x;
  MenuItem({this.name, this.color, this.x});
}

List<String> images = [];

class MyProfile extends StatefulWidget {
  final User currentUser;
  final String currentUserId;
  final String userId;

  MyProfile({this.currentUser, this.currentUserId, this.userId});
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  User get currentUser => widget.currentUser;

  int count, count1, count2;
  List<Container> feed = [];
  List items = [
    MenuItem(x: -1.0, name: 'lak', color: Colors.red),
    MenuItem(x: -0.3, name: 'message', color: Colors.purple),
    MenuItem(x: 0.3, name: 'heart', color: Colors.pink),
    MenuItem(x: 1.0, name: 'head', color: Colors.yellow),
  ];

  MenuItem active;
  
  bool toggleLive = false;

  @override
  void initState() {
    active = items[3];

    super.initState();
  }

  Future getImageURL() async {
    for (int i = 1; i <= 5; i++) {
      try {
        final StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child("userPhotos")
            .child(widget.currentUserId)
            .child("photo$i");

        final String url = await storageReference.getDownloadURL();

        images.add(url);
      } catch (e) {
        print(e);
      }
    }
  }

  getCount() async {
    try {
      QuerySnapshot snapshot = await Firestore.instance
          .collection("users")
          .document(widget.currentUserId)
          .collection("selectedList")
          .getDocuments();

      QuerySnapshot snapshot1 = await Firestore.instance
          .collection("users")
          .document(widget.currentUserId)
          .collection("chosenList")
          .getDocuments();

      QuerySnapshot snapshot2 = await Firestore.instance
          .collection("users")
          .document(widget.currentUserId)
          .collection("matchedList")
          .getDocuments();

      if (count == null) count = 0;
      if (count1 == null) count1 = 0;
      if (count2 == null) count2 = 0;

      count1 = snapshot1.documents.length;
      count = snapshot.documents.length;
      count2 = snapshot2.documents.length;
    } catch (e) {}
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
        if (item.name == "heart") {
          Navigator.push(
              context,
              SlideRightRoute(
                  page: Heart(
                        userId: widget.userId,
                        currentUserId: widget.currentUserId,
                        currentUser: currentUser,
                      ))); //Matches(userId: widget.userId,)));
        }

        if (item.name == "lak") {
          Navigator.push(
              context,
              SlideRightRoute(
                  page: Search(userId: widget.userId)));
        }
        if (item.name == "message") {
          Navigator.push(
              context,
              SlideRightRoute(
                  page: ChatRoom(
                      userId: widget.userId,
                      currentUser: currentUser,
                      currentUserId: widget.currentUserId)));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    images.clear();
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: getImageURL(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('none');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Text("");
            case ConnectionState.done:
              return Scaffold(
                bottomNavigationBar: Container(
                  height: 50,
                  width: size.width,
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
                resizeToAvoidBottomPadding: false,
                backgroundColor: backgroundColor,
                body: ListView(
                  children: <Widget>[
                    CustomSocialHeader(currentUser, images),
                    SocialInfo(),
                    Container(
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(75),
                        ),
                      ),
                      child: StaggeredGridView.countBuilder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return FocusedMenuHolder(
                            blurSize: 4,
                            blurBackgroundColor: Colors.white,
                            menuWidth: MediaQuery.of(context).size.width,
                            menuItemExtent: 50,
                            menuBoxDecoration: BoxDecoration(
                              color: Colors.blue,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 5,
                                    spreadRadius: 1)
                              ],
                            ),
                            onPressed: () {},
                            menuItems: [],
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                child: Image.network(images[index],
                                    fit: BoxFit.cover),
                              ),
                            ),
                          );
                        },
                        staggeredTileBuilder: (index) {
                          return StaggeredTile.count(1, index.isEven ? 2 : 1);
                        },
                      ),
                    ),
                    //showMap(widget.currentUser),
                    signoutButton(),

                    
                  ],
                ),
              );
          }

          return Container();
        });
  }

  showMap(User currentUser) {
    
   return currentUser.live == true ? Column(
     children: <Widget>[
       Text("Stop sharing location.", 
       style: GoogleFonts.ubuntu(color: Colors.red, fontSize: 20),),
      // SizedBox(height: MediaQuery.of(context).size.width /10) ,

       Switch(value: toggleLive,
        onChanged: (val) {
          setState(() {
             toggleLive = val;
          });
         
         // updateLive();
       }),

     ],
   ) :  Column(
     children: <Widget>[
       Text("Start sharing location.", 
       style: GoogleFonts.ubuntu(color: Colors.red, fontSize: 20),),
       SizedBox(height: MediaQuery.of(context).size.width /5) ,

       Switch(value: toggleLive,
        onChanged: (val) {
          setState(() {
             toggleLive = val;
          });
         
          //updateLive();
       }),

     ],
   );
  
    

  }

  Widget signoutButton() {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      height: 50.0,
      width: MediaQuery.of(context).size.width / 9,
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        shadowColor: Colors.greenAccent,
        color: Colors.red,
        elevation: 7.0,
        child: GestureDetector(
          onTap: () {
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            Navigator.popUntil(context, ModalRoute.withName("/"));
          },
          child: Center(
            child: Text(
              'Sign Out',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat'),
            ),
          ),
        ),
      ),
    );
  }

  Widget CustomSocialHeader(User currentUser, images) {
    return Container(
      height: 350,
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(75))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfile(widget.currentUser,
                              widget.currentUserId, images)));
                },
                child: Icon(EvaIcons.edit2Outline, color: mainColor),
              ),
            ],
          ),
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 80,
                  offset: Offset(0, 20),
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(currentUser.photo),
            ),
          ),
          Container(),
          Text(
            '${currentUser.name}',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.w700, color: mainColor),
          ),
          Text(
            currentUser.insta !=null ?'${currentUser.insta}': "",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: secondColor),
          ),
        ],
      ),
    );
  }

  Widget SocialInfo() {
    return FutureBuilder(
        future: getCount(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('none');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Text("");
            case ConnectionState.done:
              return Stack(
                children: <Widget>[
                  Container(height: 100, color: Colors.white),
                  Container(
                    padding: EdgeInsets.only(top: 25),
                    height: 100,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(75),
                        bottomRight: Radius.circular(75),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              'Likes',
                              style:
                                  TextStyle(color: secondColor, fontSize: 16),
                            ),
                            Text(
                              count.toString(),
                              style: TextStyle(
                                  color: mainColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              'Liked',
                              style:
                                  TextStyle(color: secondColor, fontSize: 16),
                            ),
                            Text(
                              count1.toString(),
                              style: TextStyle(
                                  color: mainColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              'Matches',
                              style:
                                  TextStyle(color: secondColor, fontSize: 16),
                            ),
                            Text(
                              count2.toString(),
                              style: TextStyle(
                                  color: mainColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
          }
        });
  }
}
