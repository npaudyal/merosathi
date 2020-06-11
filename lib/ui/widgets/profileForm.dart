import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:merosathi/bloc/authentication/authentication_bloc.dart';
import 'package:merosathi/bloc/authentication/authentication_event.dart';
import 'package:merosathi/bloc/profile/bloc.dart';
import 'package:merosathi/repositories/userRepository.dart';
import 'package:merosathi/ui/constants.dart';

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

  _onSubmitted() async {


    await _getlocation();
    _profileBloc.add(Submitted(
      name: _nameController.text,
      age: age,
      location: location,
      gender: gender,
      interestedIn: interestedIn,
      photo: photo

    ));
  }
  



  UserRepository get _userRepository =>widget._userRepository;


@override
  void initState() {

    _getlocation();
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    super.initState();
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if(state.isFailure) {
          Scaffold.of(context)..hideCurrentSnackBar()
         ..showSnackBar(SnackBar(
              content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Profile Creation Unsuccessful"),

                Icon(Icons.error),
              ],
            )));
        }
        if(state.isSubmitting) {
          Scaffold.of(context)..hideCurrentSnackBar()
         ..showSnackBar(SnackBar(
              content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Submitting"),
                
                CircularProgressIndicator(),
              ],
            )));
        }
        if(state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      
      },

      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              color: backgroundColor,
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: size.width,
                    child: CircleAvatar(radius:size.width * 0.3,
                    backgroundColor: Colors.transparent,
                    child: photo == null ? GestureDetector(
                        onTap: () async {
                          File getPic = await FilePicker.getFile(type: FileType.image);
                          if(getPic !=null) {
                            photo = getPic;
                          }
                        },

                        child: Image.asset('assets/profilePhoto.png'),
                    ) :  GestureDetector(
                      onTap:() async {
                          File getPic = await FilePicker.getFile(type: FileType.image);
                          if(getPic !=null) {
                            photo = getPic;
                          }
                        }, 

                        child: CircleAvatar(
                          radius: size.width * 0.3,
                          backgroundImage: FileImage(photo),

                        ),
                    )

                    ),
                    

                  ),
                  textFieldWidget(_nameController, "Name", size),
                  GestureDetector(
                    onTap: () {
                      DatePicker.showDatePicker(context, showTitleActions: true, 
                      minTime:DateTime(1900,1,1),
                      maxTime: DateTime(DateTime.now().year -19, 1,1 ),
                      onConfirm: (date) {
                        setState(() {
                          age =date;
                        });
                      },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      
      
      );
  }

  Widget textFieldWidget(controller, text, size){
    return Padding(
      
      padding: EdgeInsets.all(size.height*0.02),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: text,

          labelStyle: TextStyle(color: Colors.white, fontSize: size.height*0.03),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),

          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),

          ),

        ),

      ),

      );
  }
}