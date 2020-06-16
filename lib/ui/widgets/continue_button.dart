import 'package:flutter/material.dart';

 ContinueButton(text, onPressed) {
  return Scaffold(
    body: Center(
      child: Container(
        height: 50,
        margin: EdgeInsets.only(top:50),
        child: RaisedButton(onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(80),


        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              (Color(0xff374ABE)), (Color(0xff64B6FF))
            ]),
            borderRadius: BorderRadius.circular(30),

          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 300,
              minHeight: 50
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white
              ),
            ),
          ),
        ),
        ),
      ),
    ),
   
  );
}