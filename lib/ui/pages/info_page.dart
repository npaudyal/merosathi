import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merosathi/models/user.dart';
import 'package:merosathi/services/database.dart';
import 'package:merosathi/ui/pages/people_profile.dart';

class InfoPage extends StatefulWidget {
  final String currentUserId;
  final String userId;
  

  InfoPage(this.userId, this.currentUserId);
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {

  bool _blocked = false;
  bool _reported = false;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  PeopleProfile userProfile = new PeopleProfile();


  @override
  Widget build(BuildContext context) {
   
    print(widget.userId);
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
                        // Put the user Id in currentUsers block list
                        
                        //databaseMethods.blockUsers(userId, currentUserId)
                      },

                      )
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