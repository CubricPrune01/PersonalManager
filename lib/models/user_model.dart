import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String email;
  Timestamp accountCreated;
  String fullName;

  UserModel({
    this.uid,
    this.email,
    this.accountCreated,
    this.fullName,
  });

  UserModel.fromDocumentSnapshot({DocumentSnapshot doc}) {
    uid = doc.documentID;
    email = doc.data['email'];
    accountCreated = doc.data['accountCreated'];
    fullName = doc.data['fullName'];
  }
}