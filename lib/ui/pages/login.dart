import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merosathi/bloc/login/bloc.dart';
import 'package:merosathi/repositories/userRepository.dart';
import 'package:merosathi/ui/widgets/loginForm.dart';


class Login extends StatelessWidget {
  
  final UserRepository _userRepository;

  Login({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
       body: BlocProvider<LoginBloc>(
         create: (context) => LoginBloc(userRepository: _userRepository),
         child: LoginForm(userRepository: _userRepository),
       ),

    );
  }
}