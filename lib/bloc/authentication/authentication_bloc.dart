import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:merosathi/repositories/userRepository.dart';
import './bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final uid = await _userRepository.getUser();
        final isFirstTime = await _userRepository.isFirstTime(uid);

        if (!isFirstTime) {
          yield AuthenticatedButNotSet(uid);
         
        } else {
          yield Authenticated(uid);
          configurePushNotification();
        }
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    final isFirstTime =
        await _userRepository.isFirstTime(await _userRepository.getUser());

    if (!isFirstTime) {
      yield AuthenticatedButNotSet(await _userRepository.getUser());


    } else {
      yield Authenticated(await _userRepository.getUser());
      
    }
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }

  
configurePushNotification() async {
  final FirebaseUser firebaseUser = await _userRepository.getUserOnly();
  if(Platform.isIOS) getiOSPermission();
  _firebaseMessaging.getToken().then((token) 
  {
    
    print("Firebase token: $token");
     Firestore.instance.collection("users")
     .document(firebaseUser.uid)
     .updateData({
       "androidNotificationToken" : token
     });
  });

  _firebaseMessaging.configure(
    onLaunch: (Map<String, dynamic> message) async {
        print("On message: $message");
      final String recipientId = message['data']['recipient'];
      final String body = message['notification']['body'];
      if(recipientId == firebaseUser.uid) {
       print("Notification shown");

      } else {
       print("Notification not shown");
      }

    },
    onResume:  (Map<String, dynamic> message) async {
      print("On message: $message");
      final String recipientId = message['data']['recipient'];
      final String body = message['notification']['body'];
      if(recipientId == firebaseUser.uid) {
       print("Notification shown");

      } else {
       print("Notification not shown");
      }

    },
    onMessage:  (Map<String, dynamic> message) async {
     //
     print("On message: $message");
      final String recipientId = message['data']['recipient'];
      final String body = message['notification']['body'];
      if(recipientId == firebaseUser.uid) {
       print("Notification shown");

      } else {
       print("Notification not shown");
      }
    },

  );
}
getiOSPermission() {
_firebaseMessaging.requestNotificationPermissions(
  IosNotificationSettings(alert: true, badge: true, sound: true)
);

_firebaseMessaging.onIosSettingsRegistered.listen((settings) {
  print("Setting registered: $settings");
 });
}
}
