import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:merosathi/models/user.dart';

class SearchRepository {
  final Firestore _firestore;
  List<User> userList = [];

  SearchRepository({Firestore firestore})
      : _firestore = firestore ?? Firestore.instance;

  Future<User> chooseUser(currentUserId, selectedUserId, name, photoUrl) async {
    await _firestore
        .collection('users')
        .document(currentUserId)
        .collection('chosenList')
        .document(selectedUserId)
        .setData({});

    await _firestore
        .collection('users')
        .document(selectedUserId)
        .collection('chosenList')
        .document(currentUserId)
        .setData({});

    await _firestore
        .collection('users')
        .document(selectedUserId)
        .collection('selectedList')
        .document(currentUserId)
        .setData({
      'name': name,
      'photoUrl': photoUrl,
    });
    return getUser(currentUserId);
  }

  passUser(currentUserId, selectedUserId) async {
    await _firestore
        .collection('users')
        .document(selectedUserId)
        .collection('chosenList')
        .document(currentUserId)
        .setData({});

    await _firestore
        .collection('users')
        .document(currentUserId)
        .collection('chosenList')
        .document(selectedUserId)
        .setData({});
    return getUser(currentUserId);
  }

  Future getUserInterests(userId) async {
    User currentUser = User();

    await _firestore.collection('users').document(userId).get().then((user) {
      currentUser.name = user['name'];
      currentUser.photo = user['photoUrl'];
      currentUser.gender = user['gender'];
      currentUser.interestedIn = user['interestedIn'];
    });
    return currentUser;
  }

  Future<List> getChosenList(userId) async {
    List<String> chosenList = [];
    await _firestore
        .collection('users')
        .document(userId)
        .collection('chosenList')
        .getDocuments()
        .then((docs) {
      for (var doc in docs.documents) {
        if (docs.documents != null) {
          chosenList.add(doc.documentID);
        }
      }
    });
    return chosenList;
  }

  Future<User> getUser(userId) async {
    List<String> chosenList = await getChosenList(userId);
    User currentUser = await getUserInterests(userId);

    await _firestore.collection('users').orderBy('joined', descending: true).getDocuments().then((users) {
      for (var user in users.documents) {
        if (
            (user.documentID != userId) &&
            (currentUser.interestedIn == user['gender']) &&
            (user['interestedIn'] == currentUser.gender)) {
          User users1 = new User(
              uid: user.documentID,
              name: user['name'],
              gender: user['gender'],
              interestedIn: user['interestedIn'],
              photo: user['photoUrl'],
              age: user['age'],
              location: user['location'],
              country: user['country'],
              community: user['community'],
              heightP: user['height'],
              job: user['job'],
              bio: user['bio'],
              salary: user['salary'],
              education: user['education'],
              gotra: user['gotra'],
              live: user['live'],
              insta: user['insta'],
              religion: user['religion']);
              

          userList.add(users1);
        }
      }
    });
  }
}
