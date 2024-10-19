import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../resources/auth_methods.dart';
import '../../resources/firestore_methods.dart';
import '../models/joined_user_community.dart';
import '../utils/app_colors.dart';
import '../utils/utils.dart';
import 'comments_screen.dart';

class FeedDetailsScreen extends StatefulWidget {
  final snap;
  FeedDetailsScreen({super.key, required this.snap});

  @override
  State<FeedDetailsScreen> createState() => _FeedDetailsScreenState();
}

class _FeedDetailsScreenState extends State<FeedDetailsScreen> {
  int commentLength = 0;
  List<dynamic> listOfJoinedUsers = [];
  late User userObj;
  List<JoinedUser> joinedUsers = [];
  bool isUserJoinedCommunity = false;

  @override
  void initState() {
    super.initState();
    getComments();
    getUserJoinedCommunity();
    AuthMethods().reloadCurrentCustomer();
    print('IN Details snap: ${widget.snap}');
  }

  void getComments() async {
    await FirebaseAuth.instance.currentUser!.reload();
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['categoryId'])
          .collection('comments')
          .get();
      commentLength = snap.docs.length;
      print('commentLength : $commentLength');
    } catch (error) {
      showSnackbar(error.toString(), context);
    }
    setState(() {});
  }

  void getUserJoinedCommunity() async {
    await FirebaseAuth.instance.currentUser!.reload();
    try {
      List<dynamic> joinedUsersList = widget.snap['joinedUserIds'];

      final user = FirebaseAuth.instance.currentUser;
      if (joinedUsersList.contains(user!.uid.toString())) {
        setState(() {
          isUserJoinedCommunity = true;
        });
      } else {
        setState(() {
          isUserJoinedCommunity = false;
        });
      }
    } catch (error) {
      showSnackbar(error.toString(), context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryShadowColor,
        title: Text(widget.snap['postName']),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container(
              height: MediaQuery.of(context).size.height - 80,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Image
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 260,
                      child: Image.network(
                        widget.snap['subCategoryUrl'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 4,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('Published By: ${widget.snap['username']}', maxLines: 2, style: const TextStyle(color: Colors.grey, fontSize: 11.0),),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!isUserJoinedCommunity) {
                              final user = FirebaseAuth.instance.currentUser;
                              await FirestoreMethods().joinCommunity(
                                widget.snap['categoryId'],
                                user!.uid,
                              );
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            isUserJoinedCommunity
                                ? 'Community member'
                                : 'Join Community',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 12),
                      child: const Text(
                        'Description',
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(widget.snap['description']),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 12),
                      child: const Text(
                        'Comments',
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 12),
                      child: InkWell(
                        onTap: () {
                          if (isUserJoinedCommunity) {
                            Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CommentsScreen(
                                snap: widget.snap,
                              ),
                            ),
                          );
                          } else {
                            showSnackbar('Please join community to view comments', context);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            'View all $commentLength comments',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
