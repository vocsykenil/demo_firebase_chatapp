


import 'package:demo_firebase_chat/models/auth_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  final UsersModel? currentUser;
  final String? friendName;
  final String? friendId;
  final String? friendImage;

   const ChatScreen({super.key, this.currentUser, this.friendName, this.friendId, this.friendImage});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final chatController = TextEditingController();
  final IO.Socket _socket = IO.io('http://localhost:3000',IO.OptionBuilder().setTransports(['websocket']).build());

   _connectSocket(){
     _socket.onConnect((data) => print('Connection established'));
     _socket.onConnectError((data) => print('Connection error :: $data'));
     _socket.onDisconnect((data) => print('Socket IO Connection disconnect'));
   }
   @override
  void initState() {
     _connectSocket();
    super.initState();
  }
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
                // String? massages = chatController.text;
                // chatController.clear();
                // await FirebaseFirestore.instance.collection('users').doc(currentUser?.uid).collection('massages').doc(friendId).collection('chats').add({
                //   "senderId":currentUser?.uid,
                //   "receiverId":friendId,
                //   "massages":massages,
                //   "type":"text",
                //   "date":DateTime.now()
                // }).then((value) {
                //   FirebaseFirestore.instance.collection('users').doc(currentUser?.uid).collection('massages').doc(friendId).set({
                //     'last_msg': massages
                //   });
                // });
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
                    child: Image.network(widget.friendImage ?? ""),
                  )),
              const SizedBox(
                width: 5,
              ),
              Text(widget.friendName ?? "")
            ],
          )),
    );
  }
}
