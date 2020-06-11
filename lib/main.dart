import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merosathi/bloc/blocDelegate.dart';
import 'package:merosathi/ui/pages/home.dart';
import 'package:merosathi/repositories/userRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merosathi/bloc/authentication/authentication_bloc.dart';
import 'bloc/authentication/authentication_event.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final UserRepository _userRepository = UserRepository();

  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(BlocProvider(
      create: (context) => AuthenticationBloc(userRepository: _userRepository)
        ..add(AppStarted()),
      child: Home(userRepository: _userRepository)));
}



