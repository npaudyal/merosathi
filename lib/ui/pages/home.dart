import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merosathi/bloc/authentication/authentication_bloc.dart';
import 'package:merosathi/bloc/authentication/authentication_event.dart';
import 'package:merosathi/bloc/authentication/authentication_state.dart';
import 'package:merosathi/repositories/userRepository.dart';
import 'package:merosathi/ui/pages/splash.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final UserRepository _userRepository = UserRepository();
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);

    _authenticationBloc.add(AppStarted());

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _authenticationBloc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder(
            bloc: _authenticationBloc,
            builder: (BuildContext context, AuthenticationState state) {
                if(state is Uninitialized) {
                  return Splash();
                } else 
                return Container(
                  child: Text("Done"),
                );

            },


        ),
      ),

    ) ;
  }
}