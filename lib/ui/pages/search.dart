import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:merosathi/bloc/search/bloc.dart';
import 'package:merosathi/models/user.dart';
import 'package:merosathi/repositories/searchRepository.dart';
import 'package:merosathi/ui/pages/chatRoom.dart';
import 'package:merosathi/ui/pages/people_profile.dart';
import 'package:merosathi/ui/pages/spash_screen.dart';
import 'package:merosathi/ui/widgets/profile.dart';
import 'package:merosathi/ui/pages/my_profile.dart';
import 'package:merosathi/ui/pages/heart.dart';
import 'package:merosathi/ui/widgets/animations/slide_tansition.dart';
import 'package:merosathi/ui/widgets/animations/slide_up.dart';
import 'package:merosathi/ui/pages/no_users.dart';

class MenuItem {
  final String name;
  final Color color;
  final double x;
  MenuItem({this.name, this.color, this.x});
}

class Search extends StatefulWidget {
  final String userId;
  const Search({this.userId});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final SearchRepository _searchRepository = SearchRepository();
  SearchBloc _searchBloc;
  User currentUser;
  int difference;
  Firestore _firestore;

  List<Container> feed = [];
  List items = [
    MenuItem(x: -1.0, name: 'lak', color: Colors.red),
    MenuItem(x: -0.3, name: 'message', color: Colors.purple),
    MenuItem(x: 0.3, name: 'heart', color: Colors.pink),
    MenuItem(x: 1.0, name: 'head', color: Colors.yellow),
  ];

  MenuItem active;

  bool animation = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  getDifference(GeoPoint userLocation) async {
    Position position;
    try {
      position = await Geolocator().getCurrentPosition();
    } catch (e) {
      //print(e);
    }
    double location = await Geolocator().distanceBetween(userLocation.latitude,
        userLocation.longitude, position.latitude, position.longitude);

    difference = location.toInt();
  }

  @override
  void initState() {
    _searchBloc = SearchBloc(searchRepository: _searchRepository);
    active = items[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<SearchBloc, SearchState>(
      bloc: _searchBloc,
      builder: (context, state) {
        if (state is InitialSearchState) {
          _searchBloc.add(
            LoadUserEvent(userId: widget.userId),
          );
          return Center(
            child: SplashScreen(),
          );
        }
        if (state is LoadingState) {
          return Center(
            child: SplashScreen(),
          );
        }
        if (state is LoadUserState) {
          currentUser = state.currentUser;

          return FutureBuilder(
              future: buildContainer(_searchRepository.userList, currentUser),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('none');
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return SplashScreen();
                  case ConnectionState.done:
                    return Scaffold(
                        key: _scaffoldKey,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: items.map((k) {
                                    return _flare(k, currentUser);
                                  }).toList(),
                                ),
                              )
                            ],
                          ),
                        ),
                        body: _searchRepository.userList.length > 0
                            ? Stack(
                                children: <Widget>[
                                  LiquidSwipe(
                                    enableLoop: false,
                                    pages: feed,
                                  ),
                                ],
                              )
                            : NoUsersScreen());

                  default:
                    return Text("Default");
                }
              });
        }
      },
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
        if (item.name == "head") {
          Navigator.push(
              context,
              SlideRightRoute(
                  page: MyProfile(
                      currentUserId: widget.userId,
                      currentUser: currentUser,
                      userId: widget.userId)));
        }
        if (item.name == "heart") {
          Navigator.push(
              context,
              SlideRightRoute(
                  page: Heart(
                userId: widget.userId,
                currentUserId: widget.userId,
                currentUser: currentUser,
              ))); //Matches(userId: widget.userId,)));
        }
        if (item.name == "message") {
          Navigator.push(
              context,
              SlideRightRoute(
                  page: ChatRoom(
                      userId: widget.userId,
                      currentUser: currentUser,
                      currentUserId: currentUser.uid)));
        }
      },
    );
  }

  buildContainer(List<User> usersaa, User _currentUser) async {
    Size size = MediaQuery.of(context).size;

    for (User usera in usersaa) {
      await getDifference(usera.location);

      // print(_currentUser.location.latitude);
      if (usera.location == null) {
        return NoUsersScreen();
      } else {
        feed.add(
          Container(
            width: MediaQuery.of(context).size.width,
            child: ProfileWidget(
              padding: 0.0,
              photoHeight: size.height,
              photoWidth: size.width,
              photo: usera.photo,
              clipRadius: size.height * 0.02,
              containerHeight: size.height * 0.3,
              containerWidth: size.width,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: size.height * 0.15,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                SlideUpRoute(
                                    page: PeopleProfile(
                                        user: usera,
                                        currentUserId: widget.userId,
                                        currentUser: _currentUser)));
                          },
                          child: Row(
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  text: usera.name != null
                                      ? " ${usera.name}, "
                                      : " ",
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: size.height * 0.04,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: usera.age != null
                                          ? (DateTime.now().year -
                                                  usera.age.toDate().year)
                                              .toString()
                                          : "",
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: size.height * 0.035,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: Colors.blue,
                            ),
                            Text(
                              difference != null
                                  ? (difference / 1000).floor().toString() +
                                      " km away"
                                  : "away",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                      ],
                    ),
                  ),
                  CustomBottomBar(usera, _currentUser),
                  PlayButton(usera, _currentUser),
                  Positioned(
                    left: 120,
                    bottom: 10,
                    child: GestureDetector(
                      onTap: () {
                         Navigator.push(
                                context,
                                SlideUpRoute(
                                    page: PeopleProfile(
                                        user: usera,
                                        currentUserId: widget.userId,
                                        currentUser: _currentUser)));
                      },
                                          child: Container(
                        height: 50,
                        width: size.width / 3,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
  }

  Widget CustomBottomBar(User user, User _currentUser) {
    return Positioned(
      bottom: 0,
      width: MediaQuery.of(context).size.width,
      child: IgnorePointer(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            ClipPath(
              clipper: BottomBarClipper(),
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black,
                      Colors.black87,
                      Colors.black54,
                      Colors.black45,
                      Colors.black38,
                      Colors.black26,
                      Colors.black12
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget PlayButton(User user, User _currentUser) {
    return Positioned(
      bottom: 20,
      left: MediaQuery.of(context).size.width / 2 - 15,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              SlideUpRoute(
                  page: PeopleProfile(
                      user: user,
                      currentUserId: widget.userId,
                      currentUser: _currentUser)));
        },
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black,
                Colors.black87,
                Colors.black54,
                Colors.black
              ],
            ),
          ),
          child: Icon(Icons.arrow_drop_up,
              color: Colors.white.withOpacity(0.9), size: 20),
        ),
      ),
    );
  }
}

class BottomBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    var width = size.width;
    var height = size.height;

    path.moveTo(0, height);
    path.lineTo(0, height - 20);
    path.lineTo((width / 2 - 15) - 60, height - 20);

    var fcp = new Offset((width / 2 - 15) - 20, height - 20);
    var fep = new Offset((width / 2 - 15) - 10, height / 2);
    path.quadraticBezierTo(fcp.dx, fcp.dy, fep.dx, fep.dy);

    var scp = new Offset((width / 2 - 15) + 10, 0);
    var sep = new Offset((width / 2 - 15) + 30, height / 2);
    path.quadraticBezierTo(scp.dx, scp.dy, sep.dx, sep.dy);

    var tcp = new Offset((width / 2 - 15) + 40, height - 20);
    var tep = new Offset((width / 2 - 15) + 100, height - 20);
    path.quadraticBezierTo(tcp.dx, tcp.dy, tep.dx, tep.dy);

    path.lineTo(width, height - 20);
    path.lineTo(width, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
