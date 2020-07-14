import 'package:flutter/material.dart';



class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
              child: Column(
                
          children: <Widget>[
            Container(
              height: size.height*0.7,
              width: size.width,
              color: Colors.black,
              child: Image.asset("assets/splash screen.gif")
            ),

            
          ],
        ),
      ),
    );
      

            
  }
}

