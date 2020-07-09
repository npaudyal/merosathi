import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String name;
  String gender;
  String interestedIn;
  String country;
  String heightP;
  String community;
  String job;
  String salary;
  String bio;
  String gotra;
  String religion;
  String education;
  String photo;
  String insta;
  Timestamp age;
  GeoPoint location;
  bool live;

  User({
    this.uid,
    this.name,
    this.gender,
    this.interestedIn,
    this.photo,
    this.age,
    this.location,
    this.country,
    this.heightP,
    this.community,
    this.job,
    this.salary,
    this.bio,
    this.gotra,
    this.religion,
    this.education,
    this.insta,
    this.live
    
  });
}
