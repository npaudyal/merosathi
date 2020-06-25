import 'package:flutter/material.dart';

Widget ContinueButton( onTap, color) {
  return Container(
    height: 40.0,
    child: Material(
      borderRadius: BorderRadius.circular(20.0),
      shadowColor: color,
      color: color,
      elevation: 7.0,
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Text(
            'Continue',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat'),
          ),
        ),
      ),
    ),
  );
}
