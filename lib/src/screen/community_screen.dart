import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../resources/auth_methods.dart';
import '../utils/app_colors.dart';
import '../widget/feed_card_widget.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    AuthMethods().reloadCurrentCustomer();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('joinedUserIds', arrayContains: user!.uid)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 1.5,
          ),
          itemCount: snapshot.data == null ? 0 : snapshot.data!.docs.length,
          itemBuilder: ((context, index) => snapshot.data!.docs.isEmpty
              ? SizedBox(height: MediaQuery.of(context).size.height, child: const Center(child: Text('No communities have been joined yet', style: TextStyle(color: AppColors.primaryColor, fontSize: 14.0),),))
              : Container(
                  height: 300,
                  decoration: const BoxDecoration(
                      color: AppColors.greyColor,
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  child: PostCard(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                )),
        );
      },
    );
  }
}
