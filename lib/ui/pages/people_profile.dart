import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merosathi/bloc/search/search_bloc.dart';
import 'package:merosathi/bloc/search/search_event.dart';
import 'package:merosathi/models/user.dart';
import 'package:merosathi/repositories/searchRepository.dart';
import 'package:merosathi/services/database.dart';
import 'package:merosathi/ui/pages/chatRoom.dart';
import 'package:merosathi/ui/pages/flare.dart';
import 'package:merosathi/ui/pages/map.dart';
import 'package:merosathi/services/geolocator_service.dart';
import 'package:merosathi/ui/pages/messaging.dart';
import 'package:merosathi/ui/widgets/pageTurn.dart';
import 'package:merosathi/repositories/matchesRepository.dart';






class PeopleProfile extends StatefulWidget {
  final User user;
  final User currentUser;
  final String currentUserId;

  const PeopleProfile({this.user, this.currentUser, this.currentUserId});

  @override
  _PeopleProfileState createState() => _PeopleProfileState();
}

class _PeopleProfileState extends State<PeopleProfile> {
  final geoService = GeolocatorService();
  final SearchRepository _searchRepository = SearchRepository();
  SearchBloc searchBloc;
  FirebaseAuth auth;
  DatabaseMethods databaseMethod = new DatabaseMethods();

  int difference;
  List<String> images = [];

  int count;

  int count1;

  User get user => widget.user;
  User get currentUser => widget.currentUser;
  MatchesRepository _matchesRepository = MatchesRepository();

  String get currentUserId => widget.currentUserId;
  bool liked = false;

  

  ChatRoom chatRoom = new ChatRoom();

  getImageURL() async {
    String uid = user.uid;

    for (int i = 1; i <= 4; i++) {
      try {
        final StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child("userPhotos")
            .child(uid)
            .child("photo$i");

        final String url = await storageReference.getDownloadURL();

        images.add(url);
      } catch (e) {
        //print(e);
      }
    }
  }

  @override
  void initState() {
    searchBloc = SearchBloc(searchRepository: _searchRepository);

    getCount();
    super.initState();
  }
  Widget likeAnimation() {
    
    return Container(
        height: 200,
        width: 200,
        child: FlareActor(
          "assets/Heart (2).flr",
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: "Like",
                    
          ),
      
    );
  }
 

  Widget CustomBottomBar() {
    return Positioned(
      bottom: 0,
      width: MediaQuery.of(context).size.width,
      child: IgnorePointer(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white,
                    Colors.white,
                    Colors.white.withOpacity(0.01),
                  ],
                ),
              ),
            ),
            ClipPath(
              clipper: BottomBarClipper(),
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.blueGrey.shade800,
                      Colors.blueGrey.shade800,
                      Colors.blue.shade800,
                      Colors.blue.shade300,
                      Colors.white,
                      Colors.white,
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    images.clear();
    Size size = MediaQuery.of(context).size;

    return new FutureBuilder(
    future: getCount(),
    builder: (
      context,
      snapshot,
    ) {
      switch (snapshot.connectionState) {
        case ConnectionState.none:
          return Text('none');
        case ConnectionState.active:
        case ConnectionState.waiting:
          return Center(child: Flare());
        case ConnectionState.done:
          return Scaffold(
            body: Container(
              child: Stack(
                children: <Widget>[
                  CustomBody(),
         
                 
                  
                ],
              ),
            ),
          );
      }
    });
  }

  

  Widget CustomBody() {
   
    return ListView(
      children: <Widget>[
        CustomHeader(),
        ListTile(
          leading: Icon(Icons.format_quote),
          title: user.bio != ""
              ? Text("${user.bio}")
              : Text("I don't have a bio"),
        ),
        ListTile(
          leading: Icon(Icons.work),
          title: user.job != ""
              ? Text("${user.job}")
              : Text("Job"),
        ),
        ListTile(
          leading: Icon(Icons.school),
          title: user.education != ""
              ? Text("Studied at ${user.education}")
              : Text("University"),
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.church),
          title: user.religion != ""
              ? Text("${user.religion}")
              : Text("Religion"),
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.moneyBill),
          title: user.salary != ""
              ? Text("Earns ${user.salary}")
              : Text("Enough"),
        ),
        ListTile(
          leading: Icon(Icons.star),
          title: user.gotra != ""
              ? Text("${user.gotra} Gotra")
              : Text("Who knows?"),
        ),
        ListTile(
          leading: Icon(Icons.group),
          title: user.community != ""
              ? Text("${user.community}")
              : Text("Community"),
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.ruler),
          title: user.heightP != ""
              ? Text("${user.heightP} ")
              : Text("Height"),
        ),

         ListTile(
          leading: Icon(FontAwesomeIcons.instagram),
          title: user.insta != ""
              ? Text("${user.insta} ")
              : Text("Instagram"),
        ),
        FutureBuilder(
            future: getImageURL(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('none');
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                  return SingleChildScrollView(
                    child: StaggeredGridView.countBuilder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                child: images != null
                                    ? CachedNetworkImage(imageUrl: images[index],
                                        fit: BoxFit.cover)
                                    : Text(""),
                              ),
                            ),
                          );
                        },
                        staggeredTileBuilder: (index) {
                          return StaggeredTile.count(1, index.isEven ? 2 : 1);
                        },
                      ),
                  );
              }
            }),
        SizedBox(height: 25),
        user.live == true ? Padding(
          padding: EdgeInsets.all(25),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Maps",
              style: GoogleFonts.varelaRound(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ) : Text(""),
           user.live == true ?  GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GMap(
                        user.location.latitude, user.location.longitude)));
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
        ) : Text(""),
        SizedBox(height: 80),
        Center(
          child: Text( 
            "Joined during Covid-19",
            style: GoogleFonts.roboto(color: Colors.grey),
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }

  getImages() async {
    return FutureBuilder(
        future: getImageURL(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('none');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return StaggeredGridView.countBuilder(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      child: images != null
                          ? CachedNetworkImage(imageUrl:images[index], fit: BoxFit.cover)
                          : Text(""),
                    ),
                  );
                },
                staggeredTileBuilder: (index) {
                  return StaggeredTile.count(1, index.isEven ? 2 : 1);
                },
              );
          }
        });
  }

  

  Widget CustomHeader() {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        HeaderBackground(),
        Container(
          alignment: Alignment.center,
          height: 600,
          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              
              SizedBox(height: MediaQuery.of(context).size.height * 0.25),
              Text(
               
                user.name,
                style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
              Container(
                padding: EdgeInsets.only(top: 5, left: 20),
                child: Row(
                  children: <Widget>[
                    buildCountColumn('Likes', count),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.18),
                    buildCountColumn('Liked', count1),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.18),
                    GestureDetector(
                        onTap: () {
                          searchBloc.add(
                            SelectUserEvent(
                                name: currentUser.name,
                                photoUrl: currentUser.photo,
                                currentUserId: currentUserId,
                                selectedUserId: user.uid),
                          );

                          

                          setState(() {
                            liked = !liked;
                            count = count + 1;
                          });
                        },
                        child: liked == false
                            ? Icon(
                                FontAwesomeIcons.heart,
                                size: 20,
                              )
                            : Icon(
                                FontAwesomeIcons.solidHeart,
                                size: 20,
                                color: Colors.red,
                              )),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.18),
                    GestureDetector(
                      onTap: () async {
                        // createChatRoomAndStartConvo(
                        //     widget.currentUser, widget.user);

                        databaseMethod.openChat(currentUserId: widget.currentUser.uid, selectedUserId: widget.user.uid);

                        pageTurn(Messaging(
                          currentUser: widget.currentUser,
                          selectedUser: widget.user,
                         
                          
                        ), context);
                      },
                      child: Icon(FontAwesomeIcons.facebookMessenger),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 25),
                width: 150,
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.grey.withOpacity(0.05),
                      Colors.grey.withOpacity(0.5),
                      Colors.grey.withOpacity(0.05),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        FocusedMenuHolder(
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
            width: 150,
            height: 150,
            margin: EdgeInsets.only(top: 275),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: ExtendedNetworkImageProvider(user.photo),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
      ],
    );
  }

  Widget HeaderBackground() {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          width: 150,
          height: 150,
          margin: EdgeInsets.only(top: 275),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                blurRadius: 100,
                spreadRadius: 20,
                color: Colors.blueGrey.shade800)
          ]),
        ),
        ClipPath(
          clipper: HeaderClipper(),
          child: Container(
            margin: EdgeInsets.only(top: 5),
            height: 450,
            color: Colors.white,
          ),
        ),
        ClipPath(
          clipper: HeaderClipper(),
          child: Container(
            height: 450,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.white,Colors.red, Colors.black],
              begin: Alignment.topCenter, end: Alignment.bottomCenter
              ) ,
                
               
            ),
          ),
        ),
      ],
    );
  }

  buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Container(
            margin: EdgeInsets.only(top: 4.0),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15.0,
                color: Colors.grey,
              ),
            )),
      ],
    );
  }

  getCount() async {
    try {
      QuerySnapshot snapshot = await Firestore.instance
          .collection("users")
          .document(widget.user.uid)
          .collection("selectedList")
          .getDocuments();

      QuerySnapshot snapshot1 = await Firestore.instance
          .collection("users")
          .document(widget.user.uid)
          .collection("chosenList")
          .getDocuments();

      count1 = snapshot1.documents.length;
      count = snapshot.documents.length;
    } catch (e) {}
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    var sw = size.width;
    var sh = size.height;

    path.lineTo(sw, 0);
    path.lineTo(sw, sh);
    path.cubicTo(sw, sh * 0.7, 0, sh * 0.8, 0, sh * 0.55);
    path.lineTo(0, sh);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BottomBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    var sw = size.width;
    var sh = size.height;

    // path.moveTo(0, height);
    // path.lineTo(0, height-20);
    // path.lineTo((width/2-15)-60, height-20);

    // var fcp = new Offset((width/2-15)-20, height-20);
    // var fep = new Offset((width/2-15)-10, height/2);
    // path.quadraticBezierTo(fcp.dx, fcp.dy, fep.dx, fep.dy);

    // var scp = new Offset((width/2-15)+10, 0);
    // var sep = new Offset((width/2-15)+30, height/2);
    // path.quadraticBezierTo(scp.dx, scp.dy, sep.dx, sep.dy);

    // var tcp = new Offset((width/2-15)+40, height-20);
    // var tep = new Offset((width/2-15)+100, height-20);
    // path.quadraticBezierTo(tcp.dx, tcp.dy, tep.dx, tep.dy);

    // path.lineTo(width, height-20);
    // path.lineTo(width, height);

    path.lineTo(4 * sw / 12, 0);
    path.cubicTo(
        5 * sw / 12, 0, 5 * sw / 12, 2 * sh / 5, 6 * sw / 12, 2 * sh / 5);
    path.cubicTo(7 * sw / 12, 2 * sh / 5, 7 * sw / 12, 0, 8 * sw / 12, 0);
    path.lineTo(sw, 0);
    path.lineTo(sw, sh);
    path.lineTo(0, sh);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class Items {
  final String name;

  Items(this.name);
}
