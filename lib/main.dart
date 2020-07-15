import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merosathi/bloc/blocDelegate.dart';
import 'package:merosathi/ui/pages/home.dart';
import 'package:merosathi/repositories/userRepository.dart';
import 'package:merosathi/bloc/authentication/authentication_bloc.dart';
import 'bloc/authentication/authentication_event.dart';



void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.black
  ));
  WidgetsFlutterBinding.ensureInitialized();

  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(MyApp());

}


  class MyApp extends StatelessWidget {
  final UserRepository _userRepository = UserRepository();

    @override
    Widget build(BuildContext context) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ]);
      return MaterialApp(
        theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
        
          home: BlocProvider(
          
          
   
          create: (context) => AuthenticationBloc(userRepository: _userRepository)
            ..add(AppStarted()),
          child: Home(userRepository: _userRepository),
          ),
      );
  
    }
  }
    
     
    
 


