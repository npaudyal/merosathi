import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:merosathi/ui/widgets/photo.dart';
    

Widget ProfileWidget(
    {padding,
    photoHeight,
    photoWidth,
    clipRadius,
    photo,
    containerHeight,
    containerWidth,
    child}) {
       
       return GestureDetector(
          
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Container(
             
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[

                  

                  Container(
                    width: photoWidth,
                    height: photoHeight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(clipRadius),
                      child: PhotoWidget(
                        photoLink: photo,
                        
                      ),
                    ),
                  ),
                  Container(
                    
                    width: containerWidth,
                    height: containerHeight,
                    child: child,
                  ),
                ],
              ),
            ),
          ),
      
    
  
       );
}



