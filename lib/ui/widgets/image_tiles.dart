import 'package:flutter/material.dart';

Widget ImageTiles(onTap, height, width, image) {
 

    GestureDetector(

              onTap: onTap,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                                  child: Container(
                  height: height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:image,
                      fit: BoxFit.cover
                      
                      
                      )
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        colors: [Colors.grey[200].withOpacity(.9), Colors.grey.withOpacity(0)]
                        )
                    ),
                  ),
              ),
                ),
            );



}