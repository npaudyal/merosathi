import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class Flare extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: 500,
        width: 500,
        child: FlareActor(
          "assets/Favourite.flr",
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: "Animations",
          )),
      
    );
  }
}