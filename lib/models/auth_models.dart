import 'package:cloud_firestore/cloud_firestore.dart';

class UsersModel{
  String email;
  String image;
  String name;
  Timestamp timestamp;
  String uid;

  UsersModel({required this.email, required this.image, required this.name, required this.timestamp, required this.uid});

    factory UsersModel.fromJson(DocumentSnapshot snapshot) {
    return UsersModel(
      email: snapshot["email"],
      image: snapshot["image"],
      name: snapshot["name"],
      timestamp:snapshot["timestamp"],
      uid: snapshot["uid"],
    );
  }
}