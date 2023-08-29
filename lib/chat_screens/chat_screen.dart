import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_firebase_chat/models/auth_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final UsersModel? currentUser;
  final String? friendName;
  final String? friendId;
  final String? friendImage;

   ChatScreen({super.key, this.currentUser, this.friendName, this.friendId, this.friendImage});
  final chatController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
           Flexible(
              child: TextField(
                controller: chatController,
            decoration: const InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)))),
          )),
          const SizedBox(
            width: 10,
          ),
          IconButton(
              onPressed: () async {
                if (kDebugMode) {
                  print('Send');
                }
                String? massages = chatController.text;
                chatController.clear();
                await FirebaseFirestore.instance.collection('users').doc(currentUser?.uid).collection('massages').doc(friendId).collection('chats').add({
                  "senderId":currentUser?.uid,
                  "receiverId":friendId,
                  "massages":massages,
                  "type":"text",
                  "date":DateTime.now()
                }).then((value) {
                  FirebaseFirestore.instance.collection('users').doc(currentUser?.uid).collection('massages').doc(friendId).set({
                    'last_msg': massages
                  });
                });
              },
              icon: Icon(Icons.send, color: Colors.tealAccent.shade700))
        ]),
      ),
      appBar: AppBar(
          backgroundColor: Colors.tealAccent.shade700,
          centerTitle: true,
          leading: const BackButton(),
          title: Row(
            children: [
              SizedBox(
                  height: 50,
                  width: 50,
                  child: ClipRRect(
                    child: Image.network(friendImage ?? ""),
                  )),
              const SizedBox(
                width: 5,
              ),
              Text(friendName ?? "")
            ],
          )),
    );
  }
}
