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

class LikesTab extends StatefulWidget {
  final String userId;

  LikesTab({this.userId});
  @override
  _LikesTabState createState() => _LikesTabState();
}

class _LikesTabState extends State<LikesTab> {
  MatchesRepository matchesRepository = MatchesRepository();
  MatchesBloc _matchesBloc;
  int difference;
  @override
  void initState() {
    _matchesBloc = MatchesBloc(matchesRepository: matchesRepository);

    super.initState();
  }

  _getModalBottomSheet(BuildContext context, User user, User currentUser, String currrentUserId) {

      showModalBottomSheet(context: context, builder: (BuildContext bc) {
        Size size = MediaQuery.of(context).size;
        return Container(
          
          
          color: Colors.grey.withOpacity(0.3),
          height: MediaQuery.of(context).size.height * 0.1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                  
                  GestureDetector(
                    onTap: () {

                       Navigator.push(
                       context,
                      MaterialPageRoute(
                           builder: (context) => PeopleProfile(
                                 user: user,
                                 currentUser: currentUser,
                                currentUserId: currrentUserId,
                               )));
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(user.photo)
                    ),
                  ),

                  SizedBox(width: size.width/5.5),

                 Container(
                   height: MediaQuery.of(context).size.height * 0.05,
                   width: MediaQuery.of(context).size.width/3.5,
                   decoration: BoxDecoration(
                     
                   ),
                   
                   child: RaisedButton(
                      onPressed: () {
                          _matchesBloc.add(
                            AcceptUserEvent(
                              selectedUser: user.uid,
                              currentUser: currrentUserId,
                              currentUserPhotoUrl: currentUser.photo,
                              currentUserName: currentUser.name,
                              selectedUserPhotoUrl: user.photo,
                              selectedUserName: user.name,
                            )
                          );

                          Navigator.of(context).pop();
                      },
                      shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(80),
                      ),
                      color: Colors.lightGreen,
                      child: Center(
                        child: Text("Match", style: GoogleFonts.roboto(color: Colors.white),),

                      ),
                    
                     ),
                 ),

                 SizedBox(width:10),

                  Container(
                   height: MediaQuery.of(context).size.height * 0.05,
                   width: MediaQuery.of(context).size.width/3.5,
                   decoration: BoxDecoration(
                     
                   ),
                   
                   child: RaisedButton(
                      onPressed: () {

                            _matchesBloc.add(
                              DeleteUserEvent(
                                currentUser: currrentUserId,
                                selectedUser: user.uid
                                 )
                            );

                            Navigator.of(context).pop();
                      },
                      shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(80),
                      ),
                      color: Colors.redAccent,
                      child: Center(
                        child: Text("Pass", style: GoogleFonts.roboto(color: Colors.white),),

                      ),
                    
                     ),
                 ),


              ],
            ),
          ),
        );
      });
         

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
                stream: state.selectedList,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return  Container();
                    
                  }
                  if (snapshot.data.documents != null){
                    final user = snapshot.data.documents;

                    return SingleChildScrollView(
                    child: Container(
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

                                    _getModalBottomSheet(context, selectedUser, currentUser, currentUser.uid);

                                   
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(top: size.height*0.01),
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
                        ),
                    );
                  } else return Container();
                 
                }
           
         )

          
         

        );

      } 
        return Container();
        
      
    }
    );
  }
}
