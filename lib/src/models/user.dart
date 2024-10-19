import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String username;
  final String email;
  final String phonenumber;
  final String password;
  final List categories;
  final List subcategories;
  final bool isContributor;
  final bool isAccountDisabled;

  const User({
    required this.email,
    required this.uid,
    required this.username,
    required this.password,
    required this.phonenumber,
    required this.categories,
    required this.subcategories,
    required this.isContributor,
    required this.isAccountDisabled,
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "email": email,
        "password": password,
        "phonenumber": phonenumber,
        "isContributor": false,
        "categories": categories,
        "subcategories": subcategories,
        "isAccountDisabled": isAccountDisabled,

      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      uid: snapshot['uid'],
      username: snapshot['username'],
      email: snapshot['email'],
      password: snapshot['password'],
      phonenumber: snapshot['phonenumber'],
      isContributor: snapshot['isContributor'],
      categories: snapshot['categories'],
      subcategories: snapshot['subcategories'],
      isAccountDisabled: snapshot['isAccountDisabled'],
    );
  }
}