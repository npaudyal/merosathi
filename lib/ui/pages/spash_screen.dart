import 'dart:math';

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';


List<String> quotes = ['"Honesty is the key to a relationship. If you can fake that, you’re in."',
                      '"I love you like a fat kid loves cake."',
                      '"It wasn’t love at first sight. It took a full five minutes."',
                      '"Men are from Earth. Women are from Earth. Deal with it."',
                      '"All you need is love. But a little chocolate now and then doesn’t hurt."',
                      '"Love is an exploding cigar we willingly smoke."',
                      '"A touch of love, everyone becomes a poet."',
                      '"People should fall in love with their eyes closed."',
                      '"Love is only a dirty trick played on us to achieve continuation of the species."',
                      '"You can’t put a price tag on love. But if you could, I’d wait for it to go on sale."',
                      '"Love; A temporary insanity curable by marriage."',



];
final _random = new Random();

// generate a random index based on the list length
// and use it to retrieve the element
var element = quotes[_random.nextInt(quotes.length)];

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: SingleChildScrollView(
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/liquidlove.gif"),

              SizedBox(height: size.width * 0.6),

              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                  child: FadeAnimatedTextKit(
                    text: [element, element, element, element, element, element],
                  textStyle: GoogleFonts.lora(color:Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                  
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}

