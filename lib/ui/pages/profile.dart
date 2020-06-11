import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merosathi/bloc/profile/bloc.dart';
import 'package:merosathi/repositories/userRepository.dart';
import 'package:merosathi/ui/constants.dart';
import 'package:merosathi/ui/widgets/profileForm.dart';

class Profile extends StatelessWidget {

  final UserRepository _userRepository;
  final String userId;

  Profile({@required UserRepository userRepository, String userId})
      : assert(userRepository != null && userId !=null),
        _userRepository = userRepository, userId =userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Setup", ),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: BlocProvider<ProfileBloc>(
        create: (context) => ProfileBloc(userRepository: _userRepository),
        child: ProfileForm(userRepository: _userRepository,),
        
        ),
    );
  }
}