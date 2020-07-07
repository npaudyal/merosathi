import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:merosathi/ui/pages/chatRoom.dart';


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




blockUsers(userId, currentUserId, chatRoomId) async {

  await Firestore.instance
  .collection("chatRoom")
  .document(chatRoomId)
  .updateData({
    'blocked': true
  });

}




}

