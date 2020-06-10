import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:merosathi/repositories/userRepository.dart';
import './bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {

      final UserRepository _userRepository;

      AuthenticationBloc({@required UserRepository userRepository})
      :assert(userRepository !=null ),
      _userRepository = userRepository;





  @override
  AuthenticationState get initialState => Uninitialized();
  
    @override
    Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event,
    ) async* {
      
      if(event is AppStarted) {
        yield* _mapStartedToState();
      } else if(event is LoggedIn) {
        yield* _mapLoggedInToState();
      } else if(event is LoggedOut) {
        yield* _mappLoggedOutToState();
      }
    }

     Stream<AuthenticationState> _mapStartedToState() async* {
       try {
         final isSignedIn = await _userRepository.isSignedIn();
         if(isSignedIn) {
           final uid = await _userRepository.getUser();
           final isFirstTime = await _userRepository.isFirstTime(uid);

           if(!isFirstTime) {
             yield AuthenticatedButNotSet(uid);
           } else {
             yield Authenticated(uid);
           }
         } else {
           yield Unauthenticated();
         }
       } catch (e) {
       }
     }
     Stream<AuthenticationState> _mapLoggedInToState() async* {
       final isFirstTime = await _userRepository.isFirstTime(await _userRepository.getUser());

       if(!isFirstTime) {
         yield AuthenticatedButNotSet(await _userRepository.getUser());
       } else {
         yield Authenticated(await _userRepository.getUser());
       }
     }
  
    Stream<AuthenticationState> _mappLoggedOutToState() async* {
      yield Unauthenticated();

      _userRepository.signOut();

    }

    
    }