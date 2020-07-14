import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/splash screen.gif"),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter
              )
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white,size:25),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                         
                        ],
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.1,vertical: size.width*0.1),
                    height: MediaQuery.of(context).size.height * 0.70,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)
                      )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Welcome",style: TextStyle(
                          color: Color(0xFFF032f42),
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                        )),
                        Text("Sign to continue",style: TextStyle(
                          color: Colors.grey,
                          fontSize: 25
                        )),
                        SizedBox(height: size.width/10),
             Container(
                height: size.height * 0.07,
                width: size.width / 1.1,
                decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(30)),
                child: TextField(
                      
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        labelStyle: GoogleFonts.ubuntu(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                        
                        hintText: "Email",
                        hintStyle: GoogleFonts.ubuntu(
                          color: Colors.black38,
                        ),
                        fillColor: Colors.black,
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.deepOrange, width: 2.0),
                            borderRadius: BorderRadius.circular(30)),
                        focusColor: Colors.orangeAccent,
                        
                        
                      ),
                      cursorColor: Colors.black,
                      textAlign: TextAlign.left,
                    ),
              ),
    
                        SizedBox(height: 10),
                         Container(
                height: size.height * 0.07,
                width: size.width / 1.1,
                decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(30)),
                child: TextField(
                      
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        labelStyle: GoogleFonts.ubuntu(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                        
                        hintText: "Password",
                        hintStyle: GoogleFonts.ubuntu(
                          color: Colors.black38,
                        ),
                        fillColor: Colors.black,
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.deepOrange, width: 2.0),
                            borderRadius: BorderRadius.circular(30)),
                        focusColor: Colors.orangeAccent,
                        
                        
                      ),
                      cursorColor: Colors.black,
                      textAlign: TextAlign.left,
                    ),
              ),
               SizedBox(height: size.width/10),
               Center(
                 child: Container(
                            height: size.width* 0.15,
                            width: size.width*0.15,

                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black
                            ),
                            child: GestureDetector(
                              onTap: () {

                              },
                              child: Center(
                                child: Icon(Icons.favorite, color: Colors.white,),
                              ),
                            ),
                          ),
               ),



                        SizedBox(height: size.width/12),

                       

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Don't have an account? ",
                            style: GoogleFonts.ubuntu(fontSize:16),
                            ),

                            


                             GestureDetector(
                              onTap: () {

                              },
                              child: Container(
                                height: size.width * 0.08,
                                width: size.width /3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.green
                                  
                                ),
                                child: Center(child: Text("Sign Up", style: GoogleFonts.ubuntu(color:Colors.white),)),
                              ),
                            ),


                          ],
                        ),

                        
                      ],
                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}