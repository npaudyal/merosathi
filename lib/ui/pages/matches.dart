import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merosathi/bloc/search/bloc.dart';
import 'package:merosathi/models/user.dart';
import 'package:merosathi/repositories/matchesRepository.dart';
import 'package:merosathi/bloc/matches/matches_bloc.dart';
import 'package:merosathi/bloc/matches/matches_state.dart';
import 'package:merosathi/bloc/matches/matches_event.dart';
import 'package:merosathi/ui/pages/people_profile.dart';
import 'package:merosathi/ui/pages/spash_screen.dart';
import 'package:merosathi/ui/widgets/iconWidget.dart';
import 'package:merosathi/ui/widgets/profile.dart';
import 'package:merosathi/ui/widgets/userGender.dart';

class Matches extends StatefulWidget {
  final String userId;

  const Matches({this.userId});
  @override
  _MatchesState createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {
  MatchesRepository matchesRepository = MatchesRepository();
  MatchesBloc _matchesBloc;
  int difference;

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
    _matchesBloc = MatchesBloc(matchesRepository: matchesRepository);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<MatchesBloc, MatchesState>(
        bloc: _matchesBloc,
        builder: (BuildContext context, MatchesState state) {
          if (state is LoadingMState) {
            _matchesBloc.add(LoadListsEvent(userId: widget.userId));
            return SplashScreen();
          }
          if (state is LoadUserMState) {
            return DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: MediaQuery.of(context).size / 10,
                  child: AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    bottom: TabBar(
                      unselectedLabelColor: Colors.deepPurple,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.deepPurple, Colors.green]),
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.deepPurple,
                      ),
                      tabs: [
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Matches",
                              style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width * 0.04),
                            ),
                          ),
                        ),
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Likes",
                              style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width * 0.04),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                body: TabBarView(
                  children: <Widget>[
                    StreamBuilder<QuerySnapshot>(
                      stream: state.matchedList,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return SliverToBoxAdapter(
                            child: Container(),
                          );
                        }
                        if (snapshot.data.documents != null) {
                          final user = snapshot.data.documents;
                          return SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () async {
                                    User selectedUser = await matchesRepository
                                        .getUserDetails(user[index].documentID);
                                    User currentUser = await matchesRepository
                                        .getUserDetails(widget.userId);
                                    //await getDifference(selectedUser.location);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PeopleProfile(
                                                  user: selectedUser,
                                                  currentUser: currentUser,
                                                  currentUserId:
                                                      currentUser.uid,
                                                )));
                                  },
                                  child: ProfileWidget(
                                      padding: size.height * 0.01,
                                      photo: user[index].data['photoUrl'],
                                      photoWidth: size.width * 0.5,
                                      photoHeight: size.height * 0.3,
                                      clipRadius: size.height * 0.01,
                                      containerHeight: size.height * 0.03,
                                      containerWidth: size.width * 0.5,
                                      child: Text(
                                        "  " + user[index].data['name'],
                                        style: GoogleFonts.roboto(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      )),
                                );
                              },
                              childCount: user.length,
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                          );
                        } else {
                          return SliverToBoxAdapter(
                            child: Container(),
                          );
                        }
                      },
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: state.selectedList,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return SliverToBoxAdapter(
                              child: Container(),
                            );
                          }
                          if (snapshot.data.documents != null) {
                            final user = snapshot.data.documents;
                            return SliverGrid(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      User selectedUser =
                                          await matchesRepository
                                              .getUserDetails(
                                                  user[index].documentID);
                                      User currentUser = await matchesRepository
                                          .getUserDetails(widget.userId);

                                      // await getDifference(selectedUser.location);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PeopleProfile(
                                                    user: selectedUser,
                                                    currentUser: currentUser,
                                                    currentUserId:
                                                        currentUser.uid,
                                                  )));
                                    },
                                    child: ProfileWidget(
                                      padding: size.height * 0.01,
                                      photo: user[index].data['photoUrl'],
                                      photoWidth: size.width * 0.5,
                                      photoHeight: size.height * 0.3,
                                      clipRadius: size.height * 0.04,
                                      containerHeight: size.height * 0.03,
                                      containerWidth: size.width * 0.5,
                                      child: Center(
                                        child: Text(
                                          "  " + user[index].data['name'],
                                          style: GoogleFonts.roboto(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                childCount: user.length,
                              ),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                            );
                          } else {
                            return SliverToBoxAdapter(
                              child: Container(),
                            );
                          }
                        })
                  ],
                ),
              ),
            );
          }
          return Container();
        });
  }
}
