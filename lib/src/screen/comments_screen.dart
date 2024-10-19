import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../resources/firestore_methods.dart';
import '../models/user.dart' as model;
import '../providers/user_provider.dart';
import '../utils/app_colors.dart';
import '../widget/comment_card_widget.dart';
import 'home_view.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
  // User userObj;
  CommentsScreen({super.key, required this.snap});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentController = TextEditingController();
  //   late model.User user = Provider.of<UserProvider>(context).getUser;
  //  @override
  // void initState() {
  //   super.initState();
  //   user = UserProvider().getUser;
  // }

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // late User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryShadowColor,
        title: const Text('Comments'),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['categoryId'])
            .collection('comments')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: ((context, index) => CommentCard(
                  snap: (snapshot.data! as dynamic).docs[index].data(),
                )),
          );
        }),
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            // CircleAvatar(
            //   backgroundImage: NetworkImage(
            //     user.profilePicUrl,
            //   ),
            //   radius: 18,
            // ),
            // text input field
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 8,
                ),
                child: TextField(
                  controller: commentController,
                  // decoration: InputDecoration(
                  //     hintText: "Comment as ${user}",
                  //     border: InputBorder.none),
                ),
              ),
            ),
            // ink well widget
            InkWell(
              onTap: () async {
                final user = FirebaseAuth.instance.currentUser;
                await FirestoreMethods().postComments(
                  widget.snap['categoryId'],
                  commentController.text.toString(),
                  user!.uid,
                  user.email.toString(),
                );
                setState(() {
                  commentController.text = '';
                });
                Navigator.pushReplacement(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeView(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: const Text(
                  'Post',
                  style: TextStyle(color: AppColors.primaryColor),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
