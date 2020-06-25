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
import 'package:merosathi/ui/widgets/iconWidget.dart';
import 'package:merosathi/ui/widgets/profile.dart';
import 'package:merosathi/ui/widgets/userGender.dart';
import 'package:merosathi/ui/widgets/pageTurn.dart';
import 'package:merosathi/ui/pages/messaging.dart';

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
            return CircularProgressIndicator();
          }
          if (state is LoadUserMState) {
            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.white,
                  title: Text(
                    "Matched users",
                    style:
                        GoogleFonts.roboto(color: Colors.black, fontSize: 30.0),
                  ),
                ),
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
                        return SliverGrid(delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              User selectedUser = await matchesRepository
                                  .getUserDetails(user[index].documentID);
                              User currentUser = await matchesRepository
                                  .getUserDetails(widget.userId);
                              await getDifference(selectedUser.location);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) => Dialog(
                                        backgroundColor: Colors.transparent,
                                        child: ProfileWidget(
                                            photo: selectedUser.photo,
                                            photoHeight: size.height,
                                            padding: size.height * 0.01,
                                            photoWidth: size.width,
                                            clipRadius: size.height * 0.01,
                                            containerWidth: size.width,
                                            containerHeight: size.height * 0.2,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      size.height * 0.02),
                                              child: ListView(
                                                children: <Widget>[
                                                  SizedBox(
                                                      height:
                                                          size.height * 0.02),
                                                  Row(
                                                    children: <Widget>[
                                                      userGender(
                                                          selectedUser.gender),
                                                      Expanded(
                                                        child: Text(
                                                          " " +
                                                              selectedUser
                                                                  .name +
                                                              ", " +
                                                              (DateTime.now()
                                                                          .year -
                                                                      selectedUser
                                                                          .age
                                                                          .toDate()
                                                                          .year)
                                                                  .toString(),
                                                          style: GoogleFonts
                                                              .roboto(
                                                            color: Colors.white,
                                                            fontSize:
                                                                size.height *
                                                                    0.05,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Icon(Icons.location_on,
                                                      color: Colors.white,),
                                                      Text(
                                                        difference!=null ? (difference/1000).floor().toString() + "km away" : "away",
                                                        style: GoogleFonts.roboto(
                                                          color: Colors.white
                                                        ),
                                                      )

                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: size.height * 0.01,
                                                  ),

                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets.all(size.height*0.02),
                                                        child: iconWidget(Icons.message, () {
                                                          _matchesBloc.add(OpenChatEvent(currentUser:widget.userId, selectedUser: selectedUser.uid),);
                                                          PageTurn(MessagePage(currentUser: currentUser, selectedUser:selectedUser), context);
                                                        }, size.height*0.04, Colors.white),
                                                        )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ));
                            },
                            child: ProfileWidget(
                              padding: size.height * 0.01,
                              photo: user[index].data['photoUrl'],
                              photoWidth: size.width*0.5,
                              photoHeight: size.height * 0.3,
                              clipRadius: size.height * 0.01,
                              containerHeight: size.height * 0.03,
                              containerWidth: size.width * 0.5,
                              child: Text(
                                "  "+user[index].data['name'],
                                style: GoogleFonts.roboto(
                                  color: Colors.white
                                ),

                              )

                            ),
                          );
                        },
                        childCount: user.length,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2 ),

                        );
                      } else {
                        return SliverToBoxAdapter(
                          child: Container(),
                        );
                      }
                    },),
                    SliverAppBar(
                      backgroundColor: Colors.white,
                      pinned: true,
                      title: Text("People who liked you", 
                      style: GoogleFonts.roboto(color:Colors.black,fontSize: 30),
                      ),

                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: state.selectedList,
                      builder: (context, snapshot) {
                        if(!snapshot.hasData) {
                          return SliverToBoxAdapter(
                            child:Container() ,
                          );
                        }
                        if(snapshot.data.documents !=null) {
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

                                    await getDifference(selectedUser.location);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) => Dialog(
                                        backgroundColor: Colors.transparent,
                                        child: ProfileWidget(
                                          padding: size.height*0.01,
                                          photo: selectedUser.photo,
                                          photoHeight: size.height,
                                          photoWidth: size.width,
                                          clipRadius: size.height*0.01,
                                          containerWidth: size.width,
                                          containerHeight: size.height * 0.2,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: size.height * 0.02
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      SizedBox(height: size.height * 0.01,),
                                                      Row(
                                                        children: <Widget>[
                                                          userGender(selectedUser.gender),
                                                          Expanded(
                                                            child: Text(
                                                              " "+ selectedUser.name+ ", "+(DateTime.now().year - selectedUser.age.toDate().year).toString(),
                                                              style: GoogleFonts.roboto(
                                                                color: Colors.white,
                                                                fontSize: size.height * 0.05
                                                              ),

                                                            )
                                                            )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Icon(Icons.location_on, color: Colors.white,),
                                                           Text(
                                                        difference!=null ? (difference/1000).floor().toString() + "km away" : "away",
                                                        style: GoogleFonts.roboto(
                                                          color: Colors.white
                                                        ),
                                                      ),
                                                        ],
                                                      ),
                                                      SizedBox(height: size.height * 0.01),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          iconWidget(Icons.clear, () {
                                                            _matchesBloc.add(DeleteUserEvent(
                                                              currentUser: currentUser.uid,
                                                              selectedUser: selectedUser.uid
                                                            ));
                                                          }, size.height * 0.08, Colors.blue),
                                                          SizedBox(width: size.width * 0.05,),
                                                          iconWidget(FontAwesomeIcons.solidHeart, () {
                                                            _matchesBloc.add(
                                                              AcceptUserEvent(
                                                                selectedUser:selectedUser.uid,
                                                                currentUser: currentUser.uid,
                                                                currentUserPhotoUrl: currentUser.photo,
                                                                currentUserName: currentUser.name,
                                                                selectedUserPhotoUrl: selectedUser.photo,
                                                                selectedUserName: selectedUser.name
                                                                 ),
                                                            );
                                                          }, size.height * 0.06, Colors.red),

                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  )
                                              ],
                                            ),
                                            )
                                        ),

                                      ),

                                      );
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
                                            "  "+user[index].data['name'],
                                            style: GoogleFonts.roboto(
                                              color: Colors.white
                                            ),
                                          ),
                                        ),
                                        
                                        

                                      
                                    
                                  ),
                                );
                              },
                              childCount: user.length,
                              
                              
                              ),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),

                          );
                        } else {
                          return SliverToBoxAdapter(
                            child: Container(),
                          );
                        }
                      }
                      )
              ],
            );
            return Container();
          }
          return Container();
        });
  }
}
