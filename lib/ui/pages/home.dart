import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merosathi/bloc/authentication/authentication_bloc.dart';
import 'package:merosathi/bloc/authentication/authentication_state.dart';
import 'package:merosathi/repositories/userRepository.dart';
import 'package:merosathi/ui/pages/login.dart';
import 'package:merosathi/ui/pages/profile.dart';
import 'package:merosathi/ui/pages/search.dart';
import 'package:merosathi/ui/pages/splash.dart';

class Home extends StatelessWidget {
  final UserRepository _userRepository;

  Home({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
         
          if (state is Uninitialized) {
            return Splash();
          }
          if (state is Authenticated) {
               return Search(userId: state.userId);

             

            
            
          }
          if (state is AuthenticatedButNotSet) {
            return Profile(
              userRepository: _userRepository,
              userId: state.userId,
            );

            

           
          }
          if (state is Unauthenticated) {
            return Login(
              userRepository: _userRepository,
            );
          } else
            return Container();
        },
      ),
    );
  }
}