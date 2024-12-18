import 'package:chatapp/modes/message.dart';
import 'package:chatapp/modes/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatServices {
  

  String smailString(String s1, String s2) {
    int len = s1.length < s2.length ? s1.length : s2.length;

    for (int i = 0; i < len; i++) {
      if (s1.codeUnitAt(i) > s2.codeUnitAt(i)) {
        return s1 + s2;
      } else if (s1.codeUnitAt(i) < s2.codeUnitAt(i)) {
        return s2 + s1;
      }
    }
    return s1.length == len ? s1 + s2 : s2 + s1;
  }

  Stream<QuerySnapshot> getChat(reciver) {
    String sender = FirebaseAuth.instance.currentUser!.email!;
    
      final Stream<QuerySnapshot> chat = FirebaseFirestore.instance
          .collection(smailString(reciver.email, sender))
          .orderBy('timestamp')
          .snapshots();
      return chat; 
  }

  void sendMessage(massage, reciver, String? replayfor) {
    
      final CollectionReference chat =
          FirebaseFirestore.instance.collection(smailString(reciver.email, FirebaseAuth.instance.currentUser!.email!));

      chat.add(Message.create(massage, replayfor).messagetomap());
    
  }

  Future<List<Users>> getFriends() async {
    List<Users> user = [];
    CollectionReference users = FirebaseFirestore.instance.collection('user');
    QuerySnapshot querySnapshot = await users.get();

    for (int i = 0; i < querySnapshot.size; i++) {
      Map<dynamic, dynamic> x = querySnapshot.docs[i].data() as Map;

      if ((x['email']).toLowerCase() ==
          FirebaseAuth.instance.currentUser!.email) {
        continue;
      }
      user.add(Users(email: x['email'], name: x['name']));
    }

    return user;
  }
}
