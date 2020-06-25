import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class NameChanged extends ProfileEvent {
  final String name;

  NameChanged({@required this.name});

  @override
  List<Object> get props => [name];
}

class PhotoChanged extends ProfileEvent {
  final File photo;

  PhotoChanged({@required this.photo});

  @override
  List<Object> get props => [photo];
}

class AgeChanged extends ProfileEvent {
  final DateTime age;

  AgeChanged({@required this.age});

  @override
  List<Object> get props => [age];
}

class GenderChanged extends ProfileEvent {
  final String gender;

  GenderChanged({@required this.gender});

  @override
  List<Object> get props => [gender];
}

class InterestedInChanged extends ProfileEvent {
  final String interestedIn;

  InterestedInChanged({@required this.interestedIn});

  @override
  List<Object> get props => [interestedIn];
}

class LocationChanged extends ProfileEvent {
  final GeoPoint location;

  LocationChanged({@required this.location});

  @override
  List<Object> get props => [location];
}


class CountryChanged extends ProfileEvent {
  final String country;

  CountryChanged({@required this.country});

  @override
  List<Object> get props => [country];
}

class CommunityChanged extends ProfileEvent {
  final String community;

  CommunityChanged({@required this.community});

  @override
  List<Object> get props => [community];
}
class HeightPChanged extends ProfileEvent {
  final String heightP;

  HeightPChanged({@required this.heightP});

  @override
  List<Object> get props => [heightP];
}
class SalaryChanged extends ProfileEvent {
  final String salary;

  SalaryChanged({@required this.salary});

  @override
  List<Object> get props => [salary];
}
class ReligionChanged extends ProfileEvent {
  final String religion;

  ReligionChanged({@required this.religion});

  @override
  List<Object> get props => [religion];
}
class BioChanged extends ProfileEvent {
  final String bio;

  BioChanged({@required this.bio});

  @override
  List<Object> get props => [bio];
}
class GotraChanged extends ProfileEvent {
  final String gotra;

  GotraChanged({@required this.gotra});

  @override
  List<Object> get props => [gotra];
}
class JobChanged extends ProfileEvent {
  final String job;

  JobChanged({@required this.job});

  @override
  List<Object> get props => [job];
}
class EducationChanged extends ProfileEvent {
  final String education;

  EducationChanged({@required this.education});

  @override
  List<Object> get props => [education];
}

class Submitted extends ProfileEvent {
  final String name, gender, interestedIn;
  final DateTime age;
  final GeoPoint location;
  final File photo;
  final  String country;
  final String heightP;
  final String community;
  final String salary;
  final String gotra;
  final String bio;
  final String job;
  final String religion;
  final String education;

  Submitted(
      {@required this.name,
      @required this.gender,
      @required this.interestedIn,
      @required this.age,
      @required this.location,
      @required this.photo,
      @required this.country,
      @required this.community,
      @required this.bio,
      @required this.gotra,
      @required this.heightP,
      @required this.job,
      @required this.religion,
      @required this.salary,
      @required this.education,
      
      
      
      });

  @override
  List<Object> get props => [location, name, age, gender, interestedIn, photo, country, community, heightP, job,bio,gotra,religion,salary,education];
}