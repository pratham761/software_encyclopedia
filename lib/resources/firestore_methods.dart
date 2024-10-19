import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../src/models/sub_category_model.dart';
import 'storage_methods.dart';

class FirestoreMethods { 

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 Future<String> uploadSubCategoryImageWithDescription(
    String description,
    String postName,
    Uint8List file,
    String uid,
    String username,
    String profileImage,
  ) async {
    String res = "Some error occured";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postIdString = const Uuid().v1();
      Post post = Post(
        description: description,
        postName: postName,
        uid: uid,
        username: username,
        categoryId: postIdString,
        subCategoryId: '',
        datePublished: DateTime.now(),
        subCategoryImage: profileImage,
        subCategoryUrl: photoUrl,
        likes: [],
        joinedUserIds: []
      );

      _firestore.collection('posts').doc(postIdString).set(post.toJson());

      res = 'success';
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

    Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (error) {
      print(error.toString());
    }
  }

    Future<void> postComments(String postId, String commentText, String uid,
      String name) async {
    try {
      if (commentText.isNotEmpty) {
        String commentIdString = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentIdString)
            .set({
          'name': name,
          'uid': uid,
          'comment': commentText,
          'commentId': commentIdString,
          'createdAt': DateTime.now(),
        });
      } else {
        print('Text is empty');
      }
    } catch (error) {
      print(error.toString());
    }
  }


    Future<void> joinCommunity(String postId, String uid,) async {
    try {
        await _firestore
            .collection('posts')
            .doc(postId)
            .update(({
              'joinedUserIds': FieldValue.arrayUnion([uid])
            }));
        print('Process completed');
    } catch (error) {
      print(error.toString());
    }
  }

}