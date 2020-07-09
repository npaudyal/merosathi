import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merosathi/models/user.dart';
import 'package:merosathi/services/database.dart';
import 'package:merosathi/ui/pages/people_profile.dart';

class InfoPage extends StatefulWidget {
  final String currentUserId;
  final String userId;
  final String chatRoomId;
  

  InfoPage(this.userId, this.currentUserId, this.chatRoomId);
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {

  bool _blocked = false;
  bool _reported = false;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  PeopleProfile userProfile = new PeopleProfile();

  FirebaseAuth auth;
   String uid;
    
     
    // here you write the codes to input the data into firestore
  


_blockUsers(String userId, String currentUserId, String chatRoomId) {
  showModalBottomSheet(context: context, builder: (BuildContext bc) {
        Size size = MediaQuery.of(context).size;
        return Container(
            
            
            color: Colors.grey.withOpacity(0.3),
            height: MediaQuery.of(context).size.height * 0.1,
            child: Container(
              height: size.height*0.3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Text("Are you sure you want to block?", style: GoogleFonts.roboto(color:Colors.black45, fontSize: 17),),

                    ),

                    SizedBox(height:15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                      
                      GestureDetector(
                        onTap:  () {
                           databaseMethods.blockUsers(userId, currentUserId, widget.chatRoomId);
                           Navigator.pop(context);
                           Navigator.pop(context);
                           Navigator.pop(context);
                        },
                        child: Text("Yes", style: GoogleFonts.roboto(color: Colors.red, fontSize: 15),),
                     
                      ),

                      SizedBox(width:40),
                      
                      GestureDetector(
                        onTap:  () {

                            Navigator.of(context).pop();
                            setState(() {
                              _blocked = false;
                            });
                        },
                        child: Text("No", style: GoogleFonts.roboto(color: Colors.green, fontSize: 15),),
                      ),


                    ],),
                  ],
                ),
              ),
            ),
              );

});
}

  @override
  Widget build(BuildContext context) {
   
   
   
    return Scaffold(
      appBar: AppBar(
        title: Text("Details", style: GoogleFonts.roboto(color:Colors.black)),
        centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white54,
      flexibleSpace: SafeArea(
        child: Container(
          padding: EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back,color: Colors.black,),
              ),
            ],
          ),
        ),
      ),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal:20, vertical:20),
        child: Column(
          children: <Widget>[
            Row(
                children: <Widget>[
                    Text("Block" , style: GoogleFonts.roboto(color: Colors.red, fontSize: 16),),
                    SizedBox(width:280),
                    Switch(
                      value: _blocked,
                      onChanged: (val) {
                        setState(() {
                          _blocked = val;
                        });
                        
                        
                        _blockUsers( uid, widget.currentUserId, widget.chatRoomId);
                        
                      },

                      ),
                ],
            ),
            
            
            
             Row(
                children: <Widget>[
                    Text("Report" , style: GoogleFonts.roboto(color: Colors.red, fontSize: 16),),
                    SizedBox(width:270),
                    Switch(
                      value: _reported,
                      onChanged: (val) {
                        setState(() {
                          _reported = val;
                        });

                        //Nothing
                      }
                      )
                ],
            ),
          ],
        ),
      ),
              
             
       
    ); 
      
    
  }
}