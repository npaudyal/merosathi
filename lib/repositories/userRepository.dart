import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';


class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final Firestore _firestore;
  final GoogleSignIn _googleSignIn;
  final FacebookLogin _facebookLogin;
  

  UserRepository({FirebaseAuth firebaseAuth, Firestore firestore, GoogleSignIn googleSignIn, FacebookLogin facebookLogin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? Firestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _facebookLogin = facebookLogin ?? FacebookLogin();
       

  Future<void> signInWithEmail(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<bool> isFirstTime(String userId) async {
    bool exist;
    await Firestore.instance
        .collection('users')
        .document(userId)
        .get()
        .then((user) {
      exist = user.exists;
    });

    return exist;
  }

  Future<void> signUpWithEmail(String email, String password) async {
   // print(_firebaseAuth);
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    return Future.wait([

      _firebaseAuth.signOut(),
      _googleSignIn.signOut()
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  Future<FirebaseUser> getUserOnly() async {
    return(await _firebaseAuth.currentUser());
  }

 Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser();
  }

  Future<FirebaseUser> signInWithFacebook() async {
    final result = await _facebookLogin.logIn(['email', 'public_profile', "user_friends"]);
    switch(result.status) {
         case FacebookLoginStatus.loggedIn:
        AuthCredential cred = FacebookAuthProvider.getCredential(accessToken:result.accessToken.token);
        await _firebaseAuth.signInWithCredential(cred);
        return _firebaseAuth.currentUser();

        break;

        default:


    }

  }



  //profile setup
  Future<void> profileSetup(
      File photo,
      String userId,
      String name,
      String gender,
      String interestedIn,
      String country, 
      String heightP,
      String community,
      String salary,
      String gotra,
      String bio,
      String job,
      String religion,
      String education,
      String insta,
      bool live,
      
      
      DateTime age,

      GeoPoint location) async {
    StorageUploadTask storageUploadTask;
    storageUploadTask = FirebaseStorage.instance
        .ref()
        .child('userPhotos')
        .child(userId)
        .child(userId)
        .putFile(photo);

    return await storageUploadTask.onComplete.then((ref) async {
      await ref.ref.getDownloadURL().then((url) async {
        await _firestore.collection('users').document(userId).setData({
          'uid': userId,
          'photoUrl': url,
          'name': name,
          "location": location,
          'gender': gender,
          'interestedIn': interestedIn,
          'age': age,
          'country': country,
          'height': heightP,
          'community':community,
          'job':job,
          'gotra': gotra,
          'religion': religion,
          'salary': salary,
          'bio':bio,
          'education':education,
          'insta':insta,
          'joined': DateTime.now(),
          'live': live,
          
          


        });
      });
    });
  }

  
}