import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:merosathi/bloc/profile/bloc.dart';
import 'package:merosathi/repositories/userRepository.dart';

class ProfileForm extends StatefulWidget {

   final UserRepository _userRepository;

  ProfileForm({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;


@override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {

  final TextEditingController _nameController = TextEditingController();


  String gender, interestedIn;
  DateTime age;
  File photo;
  GeoPoint location;
  ProfileBloc _profileBloc;
  bool get isFilled => _nameController.text.isNotEmpty &&
                gender!=null &&
                interestedIn !=null &&
                photo !=null &&
                age!=null;

  bool isButtonEnabled(ProfileState state) {
    return isFilled && !state.isSubmitting;
  }

  _getlocation () async {
    Position position = await 
    Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  location = GeoPoint(position.latitude, position.longitude);

  }

  


  UserRepository get _userRepository =>widget._userRepository;

  

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}