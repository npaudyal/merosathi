import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buttonTapped(context, onTap) {
  return Center(
    child: Container(
      width: MediaQuery.of(context).size.width / 1.6,
      height: 50,
      margin: EdgeInsets.only(top: 50),
      child: RaisedButton(
        onPressed: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(80),
        ),
        child: Ink(
          width: MediaQuery.of(context).size.width / 1.01,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.grey,
              Colors.grey
            ], begin: Alignment.centerLeft, end: Alignment.centerRight),
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.all(0.0),
          child: Container(
            constraints: BoxConstraints(maxWidth: 300, minHeight: 100),
            child: Center(
              child: Text(
                "Continue",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(color:Colors.black, fontSize: 20, ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
