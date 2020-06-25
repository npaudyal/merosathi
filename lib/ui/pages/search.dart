import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:merosathi/bloc/search/bloc.dart';
import 'package:merosathi/models/user.dart';
import 'package:merosathi/repositories/searchRepository.dart';
import 'package:merosathi/ui/pages/people_profile.dart';
import 'package:merosathi/ui/widgets/iconWidget.dart';
import 'package:merosathi/ui/widgets/profile.dart';
import 'package:merosathi/ui/widgets/userGender.dart';


class Search extends StatefulWidget {
  final String userId;

  const Search({this.userId});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final SearchRepository _searchRepository = SearchRepository();
  SearchBloc _searchBloc;
  User _currentUser;
  int difference;
  Firestore _firestore;

  List<Container> feed = [];

  getDifference(GeoPoint userLocation) async {
    Position position;
    try {
      position = await Geolocator().getCurrentPosition();
    } catch (e) {
      print(e);
    }
    double location = await Geolocator().distanceBetween(userLocation.latitude,
        userLocation.longitude, position.latitude, position.longitude);

    difference = location.toInt();
  }

  @override
  void initState() {
    _searchBloc = SearchBloc(searchRepository: _searchRepository);

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
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.blueGrey),
            ),
          );
        }
        if (state is LoadingState) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.blueGrey),
            ),
          );
        }
        if (state is LoadUserState) {
          _currentUser = state.currentUser;

          return FutureBuilder(
              future: buildContainer(_searchRepository.userList, _currentUser),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('none');
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                    return Scaffold(
                        body: _searchRepository.userList.length > 0
                            ? LiquidSwipe(
                                enableLoop: false,
                                pages: feed,
                              )
                            : Text("No users"));

                  default:
                    return Text("Default");
                }
              });
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
        return Text(
          "No One Here",
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
        );
      } else {
        feed.add(Container(
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
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: size.height * 0.11,
                      ),
                      Row(
                        children: <Widget>[
                          userGender(usera.gender),
                          Expanded(
                            child: Text(
                              " " +
                                  usera.name +
                                  ", " +
                                  (DateTime.now().year -
                                          usera.age.toDate().year)
                                      .toString(),
                              style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: size.height * 0.04),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                          Text(
                            difference != null
                                ? (difference / 1000).floor().toString() +
                                    "km away"
                                : "away",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          iconWidget(FontAwesomeIcons.commentDots, () {},
                              size.height * 0.02, Colors.white),
                          iconWidget(Icons.clear, () {
                            _searchBloc
                                .add(PassUserEvent(widget.userId, usera.uid));
                          }, size.height * 0.02, Colors.blue),
                          iconWidget(FontAwesomeIcons.solidHeart, () {
                            _searchBloc.add(
                              SelectUserEvent(
                                  name: _currentUser.name,
                                  photoUrl: _currentUser.photo,
                                  currentUserId: widget.userId,
                                  selectedUserId: usera.uid),
                            );
                          }, size.height * 0.02, Colors.red),
                          iconWidget(EvaIcons.options2, () {},
                              size.height * 0.02, Colors.white),
                        ],
                      ),
                    ],
                  ),
                ),
                CustomBottomBar(usera, _currentUser),
                PlayButton(usera, _currentUser),
              ],
            ),
          ),
        ));
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
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black,
                      // Colors.black87,
                      // Colors.black54,
                      Colors.black
                      // Colors.blueGrey.shade800,
                      // Colors.blue.shade800,
                      // Colors.blue.shade300,
                      // Colors.white,
                      // Colors.white,
                    ],
                  ),
                ),
              ),
            ),

            //  Container(
            //    padding: EdgeInsets.only(bottom:10, right: 10),
            //   //  child: GestureDetector
            //   //  (
            //   //    onTap: () {
            //   //  Navigator.push(context, MaterialPageRoute(builder: (context) => PeopleProfile(user: user, currentUserId: widget.userId, currentUser: _currentUser)));

            //   //    },
            //      child: IconButton(
            //        icon: Icon(Icons.arrow_upward, color: Colors.white,),
            //        onPressed: () {

            //           Navigator.push(context, MaterialPageRoute(builder: (context) => PeopleProfile(user: user, currentUserId: widget.userId, currentUser: _currentUser)));
            //        },
            //         ),

            //      ),
          ],
        ),
      ),
    );
  }

  Widget PlayButton(User user, User _currentUser) {
    return Positioned(
      bottom: 20,
      left: MediaQuery.of(context).size.width / 2 - 15,
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
        child: IconButton(
          padding: EdgeInsets.only(right: 20),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PeopleProfile(
                        user: user,
                        currentUserId: widget.userId,
                        currentUser: _currentUser)));
          },
          icon: Icon(Icons.arrow_drop_up,
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
