import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../resources/auth_methods.dart';
import '../providers/user_provider.dart';
import '../utils/app_colors.dart';
import '../widget/feed_card_widget.dart';
import '../models/user.dart' as model;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenNewState();
}

class _DashboardScreenNewState extends State<DashboardScreen> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of grid items per row
        mainAxisSpacing: 10.0, // Spacing between items vertically
        crossAxisSpacing: 10.0, // Spacing between items horizontally
        childAspectRatio: 1.5, // Aspect ratio of each grid item (adjust as needed)
      ),
            itemCount: snapshot.data == null ? 0 : snapshot.data!.docs.length,
            itemBuilder: ((context, index) => snapshot.data == null
                ? Container()
                : Container(
                  height: 300,
                  decoration: const BoxDecoration(
                    color: AppColors.greyColor,
                    borderRadius: BorderRadius.all(Radius.circular(12.0))
                  ),
                    child: PostCard(
                      snap: snapshot.data!.docs[index].data(),
                    ),
                  )),
          );
        },
      );
  }
}
