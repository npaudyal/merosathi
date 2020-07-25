import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merosathi/bloc/authentication/bloc.dart';
import 'package:merosathi/models/user.dart';
import 'package:merosathi/ui/pages/chatRoom.dart';
import 'package:merosathi/ui/pages/heart.dart';
import 'package:merosathi/ui/pages/map.dart';
import 'package:merosathi/ui/pages/search.dart';
import 'package:merosathi/ui/pages/edit_profile.dart';
import 'package:merosathi/ui/widgets/animations/slide_tansition.dart';
import 'package:shimmer/shimmer.dart';


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
  
 bool showImageWidget = false;

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
        //print(e);
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

  User user1 = new User();

   Future getUserInfo(currentUserId) async {
    await Firestore.instance
        .collection("users")
        .document(currentUserId)
        .get()
        .then((data) {
      
        user1.bio = data['bio'];
        user1.job = data['job'];
        user1.education = data['education'];
        user1.religion = data['religion'];
        user1.salary = data['salary'];
        user1.gotra = data['gotra'];
        user1.name = data['name'];
        user1.location = data['location'];
        user1.heightP = data['height'];
        user1.community = data['community'];
        user1.uid = data['uid'];
        user1.gender = data['gender'];
        user1.interestedIn = data['interestedIn'];
        user1.photo = data['photoUrl'];
        user1.age = data['age'];
        user1.country = data['country'];
        user1.live = data['live'];
        user1.insta = data['insta'];
     
    });
  }

  @override
  Widget build(BuildContext context) {
   
    images.clear();
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: Future.wait([getImageURL(), getUserInfo(widget.currentUserId)]),
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
                    SizedBox(height:size.width *0.02),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:25.0),
                      child: Column(
                       
                        children: <Widget>[
                       ListTile(
          leading: Icon(Icons.format_quote),
          title: user1.bio !=""
              ? Text("${user1.bio}")
              : Text("I don't have a bio"),
        ),
        ListTile(
          leading: Icon(Icons.work),
          title:user1.job != ""
              ? Text("${user1.job}")
              : Text("Job"),
        ),
        ListTile(
          leading: Icon(Icons.school),
          title:user1.education != null
              ? Text("Studied at ${user1.education}")
              : Text("University"),
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.church),
          title:user1.religion != null
              ? Text("${user1.religion}")
              : Text("Religion"),
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.moneyBill),
          title: user1.salary != null
              ? Text("Earns ${user1.salary}")
              : Text("Enough"),
        ),
        ListTile(
          leading: Icon(Icons.star),
          title: user1.gotra != null
              ? Text("${user1.gotra} Gotra")
              : Text("Who knows?"),
        ),
        ListTile(
          leading: Icon(Icons.group),
          title: user1.community != null
              ? Text("${user1.community}")
              : Text("Community"),
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.ruler),
          title: user1.heightP != null
              ? Text("${user1.heightP} ")
              : Text("Height"),
        ),

         ListTile(
          leading: Icon(FontAwesomeIcons.instagram),
          title:user1.insta != null
              ? Text("${user1.insta}")
              : Text("Instagram"),
        ),
                      
                        ],
                      ),
                    ),
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
                                child: CachedNetworkImage(
                                  imageUrl: images[index],
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

                    showMap(),

                    
                   
                    
                  ],
                ),
              );
          }

          return Container();
        });
  }

  updateLive(userId, value) async {
    await Firestore.instance
    .collection("users")
    .document(userId)
    .updateData({
      'live' : value
    });
  }

  showMap() {
    
    
   bool toggleLive = user1.live;
    
   return user1.live == true ? Column(

     children: <Widget>[
       SizedBox(height:10),
       Padding(
         padding:  EdgeInsets.only(left:10),
         child: Text(
                "Maps",
                style: GoogleFonts.varelaRound(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
               
              ),
       ),
       SizedBox(height:10),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GMap(
                        user1.location.latitude, user1.location.longitude)));
          },
          child: Container(
            padding: EdgeInsets.all(5),
            height: 180,
            width: MediaQuery.of(context).size.width / 1.05,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/maps.png"),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
       Text("Stop sharing location.", 
       style: GoogleFonts.ubuntu(color: Colors.red, fontSize: 20),),
      // SizedBox(height: MediaQuery.of(context).size.width /10) ,

       Switch(value: toggleLive,
        onChanged: (val) {
          setState(() {
             toggleLive = val;
          });
         
             updateLive(user1.uid, val);
          
         
         // updateLive();
       }),

     ],
   ) :  Column(
     children: <Widget>[
       Text("Start sharing location.", 
       style: GoogleFonts.ubuntu(color: Colors.red, fontSize: 20),),
       SizedBox(height: MediaQuery.of(context).size.width /20) ,

       Switch(value: toggleLive,
        onChanged: (val) {
          setState(() {
             toggleLive = val;
          });
         
          updateLive(user1.uid, val);
       }),

     ],
   );
  
    

  }

  Widget signoutButton() {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      height: 50.0,
      width: MediaQuery.of(context).size.width/5 ,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                 Navigator.popUntil(context, ModalRoute.withName("/"));
                },
                child: Icon(FontAwesomeIcons.powerOff, size: 20),
              ),
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
            child: CachedNetworkImage(imageUrl: currentUser.photo,
              imageBuilder: (context,imageProvider) => CircleAvatar(
                
                backgroundImage: imageProvider,
              ),            
            )
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
