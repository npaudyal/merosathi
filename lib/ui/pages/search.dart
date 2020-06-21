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
        if (state is LoadUserState)  {
          _currentUser = state.currentUser;

          //print(difference);
            
         // buildContainer(_searchRepository.userList, _currentUser);

          // return Scaffold(
          //   body: LiquidSwipe(
          //     enableLoop: false,
          //      pages: feed
          //      ),
          // );


          return 
          FutureBuilder(
            future: buildContainer(_searchRepository.userList, _currentUser),
            builder: (context, snapshot) {
              switch(snapshot.connectionState) {
                case ConnectionState.none:
                return Text('none');
                case ConnectionState.active:
                case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                
                 return Scaffold(
            body: LiquidSwipe(
              enableLoop: false,
               pages: feed
               ),
          );

          default: 
          return Text("Default");

              }
            }
            
            );




          // _user = state.user;

          // print(_searchRepository.userList[0].uid);
          // print(_searchRepository.userList[1].uid);
          // print(_searchRepository.userList[2].uid);

          //buildContainer(_searchRepository.userList);

          // getDifference(_user.location);
          // if (_user.location == null) {
          //   return Text(
          //     "No One Here",
          //     style: TextStyle(
          //         fontSize: 20.0,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.black),
          //   );
          // } else {
          //   return Scaffold(
          //     body: Column(
          //       children: feed,
          //     ),
          //   );

          // }
          // return ProfileWidget(
          //   padding: size.height * 0.035,
          //   photoHeight: size.height * 0.824,
          //   photoWidth: size.width * 0.95,
          //   photo: _user.photo,
          //   clipRadius: size.height * 0.02,
          //   containerHeight: size.height * 0.3,
          //   containerWidth: size.width * 0.9,
          //   child: Padding(
          //     padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: <Widget>[
          //         SizedBox(
          //           height: size.height * 0.06,
          //         ),
          //         Row(
          //           children: <Widget>[
          //             userGender(_user.gender),
          //             Expanded(
          //               child: Text(
          //                 " " +
          //                     _user.name +
          //                     ", " +
          //                     (DateTime.now().year - _user.age.toDate().year)
          //                         .toString(),
          //                 style: TextStyle(
          //                     color: Colors.white,
          //                     fontSize: size.height * 0.05),
          //               ),
          //             )
          //           ],
          //         ),
          //         Row(
          //           children: <Widget>[
          //             Icon(
          //               Icons.location_on,
          //               color: Colors.white,
          //             ),
          //             Text(
          //               difference != null
          //                   ? (difference / 1000).floor().toString() +
          //                       "km away"
          //                   : "away",
          //               style: TextStyle(color: Colors.white),
          //             )
          //           ],
          //         ),
          //         SizedBox(
          //           height: size.height * 0.05,
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceAround,
          //           children: <Widget>[
          //             iconWidget(EvaIcons.flash, () {}, size.height * 0.04,
          //                 Colors.yellow),
          //             iconWidget(Icons.clear, () {
          //               _searchBloc
          //                   .add(PassUserEvent(widget.userId, _user.uid));
          //             }, size.height * 0.08, Colors.blue),
          //             iconWidget(FontAwesomeIcons.solidHeart, () {
          //               _searchBloc.add(
          //                 SelectUserEvent(
          //                     name: _currentUser.name,
          //                     photoUrl: _currentUser.photo,
          //                     currentUserId: widget.userId,
          //                     selectedUserId: _user.uid),
          //               );
          //             }, size.height * 0.06, Colors.red),
          //             iconWidget(EvaIcons.options2, () {}, size.height * 0.04,
          //                 Colors.white)
          //           ],
          //         )
          //       ],
          //     ),
          //   ),
          // );
        }
        // else
        //   return Container();
      },
    );
  }

  


  buildContainer(List<User> usersaa, User _currentUser) async {
    Size size = MediaQuery.of(context).size;

    for (User usera in usersaa)   {
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
            containerWidth: size.width * 0.9,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: size.height * 0.06,
                  ),
                  Row(
                    children: <Widget>[
                      userGender(usera.gender),
                      Expanded(
                        child: Text(
                          " " +
                              usera.name +
                              ", " +
                              (DateTime.now().year - usera.age.toDate().year)
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
                            ? (difference / 1000).floor().toString() + "km away"
                            : "away",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      iconWidget(EvaIcons.home, () {}, size.height * 0.04,
                          Colors.yellow),
                      iconWidget(Icons.clear, () {
                        _searchBloc
                            .add(PassUserEvent(widget.userId, usera.uid));
                      }, size.height * 0.08, Colors.blue),
                      iconWidget(FontAwesomeIcons.solidHeart, () {
                        _searchBloc.add(
                          SelectUserEvent(
                              name: _currentUser.name,
                              photoUrl: _currentUser.photo,
                              currentUserId: widget.userId,
                              selectedUserId: usera.uid),
                        );
                      }, size.height * 0.06, Colors.red),
                      iconWidget(EvaIcons.options2, () {}, size.height * 0.04,
                          Colors.white),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
      }
    }
  }
}
