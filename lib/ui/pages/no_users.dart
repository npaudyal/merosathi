
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';


class NoUsersScreen extends StatelessWidget {
  const NoUsersScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/nousers.gif"),

            

            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: FadeAnimatedTextKit(
                  text: ["There are no users around you!", "Get a life!", "There are no users around you!", "Get a life!", ],
                textStyle: GoogleFonts.lora(color:Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
                
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}

