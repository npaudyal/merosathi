import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merosathi/bloc/matches/matches_bloc.dart';
import 'package:merosathi/bloc/matches/matches_event.dart';
import 'package:merosathi/bloc/matches/matches_state.dart';
import 'package:merosathi/models/user.dart';
import 'package:merosathi/repositories/matchesRepository.dart';
import 'package:merosathi/ui/pages/people_profile.dart';
import 'package:merosathi/ui/widgets/profile.dart';

class MatchTab extends StatefulWidget {
  final String userId;

  const MatchTab({this.userId});
  @override
  _MatchTabState createState() => _MatchTabState();
}

class _MatchTabState extends State<MatchTab> {
  MatchesRepository matchesRepository = MatchesRepository();
  MatchesBloc _matchesBloc;
  int difference;
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
            return Center(child: CircularProgressIndicator());
          }
          if (state is LoadUserMState) {


            return SingleChildScrollView(
              
             child: StreamBuilder<QuerySnapshot>(
                    stream: state.matchedList,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                        
                      }
                      if (snapshot.data.documents != null){
                        final user = snapshot.data.documents;

                        return SizedBox(
                          height: size.height,
                          
                           child: GridView.builder(
                           physics: ScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2) ,
                             itemBuilder: (BuildContext context, int index) {
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
                                                  currentUserId: currentUser.uid,
                                                )));
                                  },
                                  
                                  child: Padding(
                                      padding: EdgeInsets.only(top:size.height * 0.01),
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
                                  ),
                                );
                              

                             },
                             itemCount: user.length,
                             ),
                        );
                      } else return Container();
                     
                    },
             ),
            );
        }
        return Container();
         
      }
    );
  }
}
