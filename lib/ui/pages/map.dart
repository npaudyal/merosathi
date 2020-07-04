import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:merosathi/services/geolocator_service.dart';
class GMap extends StatefulWidget {
  final double latitude;
  final double longitude;
  GMap(this.latitude, this.longitude);

  @override
  _GMapState createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  final GeolocatorService geoService = GeolocatorService();
  Completer<GoogleMapController> _controller = Completer();


  void _setMapStyle(GoogleMapController controller) async {
    String style = await DefaultAssetBundle.of(context).loadString("assets/map_style.json");
    controller.setMapStyle(style);
      }

    Set<Marker> _marker = HashSet<Marker>();


   
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.latitude, widget.longitude),
            zoom: 18.0),
          
          myLocationEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            
            _setMapStyle(controller);
           
          },
          
          
          ),
      )
    );
  }

}