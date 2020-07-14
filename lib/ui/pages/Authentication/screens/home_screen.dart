import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merosathi/bloc/authentication/bloc.dart';
import 'package:merosathi/bloc/login/login_bloc.dart';
import 'package:merosathi/bloc/login/login_state.dart';
import 'package:merosathi/repositories/userRepository.dart';
import 'package:merosathi/ui/pages/Authentication/animations/fade_animation.dart';
import 'package:merosathi/ui/pages/Authentication/components/customButtonAnimation.dart';
import 'package:merosathi/ui/pages/Authentication/components/custom_button.dart';
import 'package:merosathi/ui/pages/Authentication/screens/login_screen.dart';
import 'package:merosathi/ui/widgets/loginForm.dart';

class HomeScreen extends StatefulWidget {
  final UserRepository userRepository;

  HomeScreen(this.userRepository);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Scaffold(
      backgroundColor: Colors.black,
      body:  BlocProvider<LoginBloc>(
         create: (context) => LoginBloc(userRepository:widget.userRepository),
         child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
           // Image.asset("assets/download.png", fit: BoxFit.cover),
             
               
                 Image.asset("assets/splash screen.jpg"),
               
             
              
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Color(0xFFF001117).withOpacity(0),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: size.width /14),
              margin: EdgeInsets.only(top: size.width* 0.2,bottom: size.width*0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    FadeAnimation(2.4,Text("Find your", style: GoogleFonts.ubuntu(
                    color: Colors.white,
                    fontSize: 22,
                    letterSpacing: 2
                  ))),
                  FadeAnimation(2.6,Text("  JODI", style: GoogleFonts.shadowsIntoLight(
                    color: Colors.white,
                    fontSize: 40, 
                    fontWeight: FontWeight.bold
                  ))),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FadeAnimation(2.8,CustomButton(
                        label: "Sign up",
                        background: Colors.transparent,
                        fontColor: Colors.white,
                        borderColor: Colors.white,
                      )),
                      SizedBox(height: 20),
                      FadeAnimation(3.2,CustomButtonAnimation(
                        label: "Sign In",
                        backbround: Colors.white,
                        borderColor: Colors.white,
                        fontColor: Color(0xFFF001117),
                        child: LoginForm(userRepository: widget.userRepository),
                      )),
                      SizedBox(height: 30),
                      FadeAnimation(3.4,Text("Forgot password", style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        decoration: TextDecoration.underline
                      )))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
      

      
    
  }
  }