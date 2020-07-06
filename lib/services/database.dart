import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseMethods{

  

createChatRoom(String chatRoomId, chatRoomMap) {
  Firestore.instance.collection("chatRoom")
  .document(chatRoomId)
  .setData(chatRoomMap)
  .catchError((e) {
    print(e.toString());
  });
}

addConversationMessages(String chatRoomId, messageMap) async {
  Firestore.instance
  .collection("chatRoom")
  .document(chatRoomId)
  .collection("chats")
  .add(messageMap).catchError((e) {
    print(e);
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

getChatRooms(String userName) async {
  return await Firestore.instance
  .collection("chatRoom")
  .where("users", arrayContains: userName)
  .snapshots();
}




blockUsers(userId, currentUserId) async {

  await Firestore.instance
  .collection("users")
  .document(currentUserId)
  .collection("blocked")
  .document(userId)
  .setData({

  });

}




}

