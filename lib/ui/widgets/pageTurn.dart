import 'package:flutter/material.dart';

void PageTurn(Widget pageName, context ) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return pageName;
  }));
}