import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseMethods{

  

createChatRoom(String chatRoomId, chatRoomMap) {
  Firestore.instance.collection("chatRoom")
  .document(chatRoomId)
  .setData(chatRoomMap)
  .catchError((e) {
   // print(e.toString());
  });
}

addConversationMessages(String chatRoomId, messageMap) async {
  Firestore.instance
  .collection("chatRoom")
  .document(chatRoomId)
  .collection("chats")
  
  .add(messageMap).catchError((e) {
   // print(e);
  });
}

getConversationMessages(String chatRoomId) async {
  return Firestore.instance
  .collection("chatRoom")
  .document(chatRoomId)
  .collection("chats")
  .orderBy("time", descending: false)
  .snapshots();
  
}



chatRoomExists(String chatRoomId) async {
  bool exists = false;
try{
 await Firestore.instance
  .collection("chatRoom")
  .document(chatRoomId)
  .get().then((doc){
    if(doc.exists) {
      exists = true;
    } else {
      exists = false;
    }
       
      
      
  });
  return exists;
} catch (e) {
  return false;
}

}

deleteMessages(String chatRoomId) async {
  await Firestore.instance
  .collection("chatRoom")
  .document(chatRoomId)
  .delete();

}




blockUsers(userId, currentUserId) async {

  await Firestore.instance
  .collection("users")
  .document(currentUserId)
  .collection("blocked")
  .document(userId)
  .setData({});

  await Firestore.instance
  .collection("users")
  .document(userId)
  .collection("blocked")
  .document(currentUserId)
  .setData({});

}

 Future openChat({currentUserId, selectedUserId}) async {
    await Firestore.instance
        .collection('users')
        .document(currentUserId)
        .collection('chats')
        .document(selectedUserId)
        .setData({'timestamp': DateTime.now()});

    await Firestore.instance
        .collection('users')
        .document(selectedUserId)
        .collection('chats')
        .document(currentUserId)
        .setData({'timestamp': DateTime.now()});

   
  }

  void deleteUser(currentUserId, selectedUserId) async {
    return await Firestore.instance
        .collection('users')
        .document(currentUserId)
        .collection('selectedList')
        .document(selectedUserId)
        .delete();
  }

  



}

