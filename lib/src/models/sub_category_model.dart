import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String postName;
  final String uid;
  final String username;
  final String categoryId;
  final String subCategoryId;
  final datePublished;
  final String subCategoryUrl;
  final String subCategoryImage;
  final likes;
  final List<String> joinedUserIds;

  const Post({
    required this.description,
    required this.postName,
    required this.uid,
    required this.subCategoryImage,
    required this.username,
    required this.categoryId,
    required this.subCategoryId,
    required this.datePublished,
    required this.subCategoryUrl,
    required this.likes,
    required this.joinedUserIds,
  });

  Map<String, dynamic> toJson() => {
        "description": description,
        "postName": postName,
        "uid": uid,
        "subCategoryImage": subCategoryImage,
        "username": username,
        "categoryId": categoryId,
        "subCategoryId": subCategoryId,
        "datePublished": datePublished,
        "subCategoryUrl": subCategoryUrl,
        "likes": likes,
        "joinedUserIds": joinedUserIds,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      description: snapshot['description'],
      postName: snapshot['postName'],
      uid: snapshot['uid'],
      subCategoryImage: snapshot['subCategoryImage'],
      username: snapshot['username'],
      categoryId: snapshot['categoryId'],
      subCategoryId: snapshot['subCategoryId'],
      datePublished: snapshot['datePublished'],
      subCategoryUrl: snapshot['subCategoryUrl'],
      likes: snapshot['likes'],
      joinedUserIds: snapshot['joinedUserIds'],
    );
  }
}
