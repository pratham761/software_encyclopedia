import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../resources/auth_methods.dart';
import '../../resources/firestore_methods.dart';
import '../models/user.dart' as model;
import '../providers/user_provider.dart';
import '../screen/feed_details_screen.dart';
import '../utils/utils.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({required this.snap, super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLength = 0;

  @override
  void initState() {
    super.initState();
    getComments();
    AuthMethods().reloadCurrentCustomer();
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

  @override
  Widget build(BuildContext context) {
    // final model.User user = Provider.of<UserProvider>(context).getUser;
    return InkWell(
      onTap: () async {
        print('widget snap : ${widget.snap}');

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FeedDetailsScreen(
              snap: widget.snap,
            ),
          ),
        );
      },
      child: Container(
        color: Colors.transparent,
        height: 240,
        // padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsetsDirectional.symmetric(
                  vertical: 4, horizontal: 16),
              child: Row(
                children: [
                  // CircleAvatar(
                  //   radius: 16,
                  //   backgroundImage: NetworkImage(
                  //     widget.snap['profileImage'],
                  //   ),
                  // ),
                  // Expanded(
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(
                  //       left: 8,
                  //     ),
                  //     child: Column(
                  //       mainAxisSize: MainAxisSize.min,
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text(
                  //           widget.snap['username'],
                  //           style: const TextStyle(fontWeight: FontWeight.bold),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // widget.snap['uid'].toString() == user.uid
                  //     ? IconButton(
                  //         onPressed: () {
                  //           showDialog(
                  //             context: context,
                  //             builder: ((context) => Dialog(
                  //                   child: ListView(
                  //                     shrinkWrap: true,
                  //                     padding: const EdgeInsets.symmetric(
                  //                         vertical: 16),
                  //                     children: ['Delete']
                  //                         .map((e) => InkWell(
                  //                               onTap: () async {
                  //                                 FirestoreMethods().deletePost(
                  //                                     widget.snap['postId']);
                  //                                 Navigator.of(context).pop();
                  //                               },
                  //                               child: Container(
                  //                                 padding:
                  //                                     const EdgeInsets.symmetric(
                  //                                         vertical: 12,
                  //                                         horizontal: 16),
                  //                                 child: Text(e),
                  //                               ),
                  //                             ))
                  //                         .toList(),
                  //                   ),
                  //                 )),
                  //           );
                  //         },
                  //         icon: const Icon(Icons.more_vert_outlined),
                  //       )
                  //     : Container(),
                ],
              ),
            ),
            // // Image Area
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.14,
                width: MediaQuery.of(context).size.width / 2.4,
                child: Image.network(
                  widget.snap['subCategoryUrl'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              child: Text(widget.snap['postName']),
            ),
            // Comment . like area
            // Row(
            //   children: [
            //     LikeAnimation(
            //       isAnimating: widget.snap['likes'].contains(user.uid),
            //       smallLike: true,
            //       child: IconButton(
            //         onPressed: () async {
            //           await FirestoreMethods().likePost(
            //               widget.snap['postId'], user.uid, widget.snap['likes']);
            //         },
            //         icon: widget.snap['likes'].contains(user.uid)
            //             ? const Icon(
            //                 Icons.favorite,
            //                 color: Colors.red,
            //               )
            //             : const Icon(Icons.favorite_border_outlined),
            //       ),
            //     ),
            //     IconButton(
            //       onPressed: () {
            //         Navigator.of(context).push(
            //           MaterialPageRoute(
            //             builder: (context) => CommentsScreen(
            //               snap: widget.snap,
            //             ),
            //           ),
            //         );
            //       },
            //       icon: const Icon(
            //         Icons.mode_comment,
            //         color: Colors.white,
            //       ),
            //     ),
            //     IconButton(
            //       onPressed: () {},
            //       icon: const Icon(
            //         Icons.send,
            //         color: Colors.white,
            //       ),
            //     ),
            //     Expanded(
            //       child: Align(
            //         alignment: Alignment.bottomRight,
            //         child: IconButton(
            //           onPressed: () {},
            //           icon: const Icon(Icons.bookmark_border),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),

            // Description
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Column(
            //     mainAxisSize: MainAxisSize.min,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       DefaultTextStyle(
            //         style: Theme.of(context)
            //             .textTheme
            //             .titleSmall!
            //             .copyWith(fontWeight: FontWeight.w800),
            //         child: Text(
            //           '${widget.snap['likes'].length} likes',
            //           style: Theme.of(context).textTheme.bodyMedium,
            //         ),
            //       ),
            //       Container(
            //         width: MediaQuery.of(context).size.width,
            //         padding: const EdgeInsets.only(top: 8),
            //         child: RichText(
            //           text: TextSpan(
            //               style: const TextStyle(
            //                 color: Colors.white,
            //               ),
            //               children: [
            //                 TextSpan(
            //                   text: widget.snap['username'],
            //                   style: const TextStyle(fontWeight: FontWeight.bold),
            //                 ),
            //                 TextSpan(
            //                   text: '  ${widget.snap['description']}',
            //                 )
            //               ]),
            //         ),
            //       ),
            //       // comments
            //       InkWell(
            //         onTap: () {},
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(vertical: 4),
            //           child: Text(
            //             'View all $commentLength comments',
            //             style:
            //                 const TextStyle(fontSize: 16, color: Colors.grey),
            //           ),
            //         ),
            //       ),

            //       // date
            //       Padding(
            //         padding: const EdgeInsets.symmetric(vertical: 4),
            //         child: Text(
            //           DateFormat.yMMMd()
            //               .format(widget.snap['datePublished'].toDate()),
            //           style: const TextStyle(fontSize: 16, color: Colors.grey),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
