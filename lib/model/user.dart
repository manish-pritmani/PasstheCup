import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String email;
  final String password;
  final String uid;
  final String deviceInfo;

  User({
    this.name,
    this.email,
    this.password,
    this.uid,
    this.deviceInfo,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      name: doc['name'],
      email: doc['email'],
      password: doc['password'],
      uid: doc['uid'],
      deviceInfo: doc['deviceInfo'],
    );
  }
}