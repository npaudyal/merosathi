import 'package:cloud_firestore/cloud_firestore.dart';

class Users{
  String uid;
  String name;
  String gender;
  String interestedIn;
  String photo;
  Timestamp age;
  GeoPoint location;


  Users(
  this.uid,
  this.name,
  this.gender,
  this.interestedIn,
  this.photo,
  this.age,
  this.location


  );

}