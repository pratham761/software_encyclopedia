import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:software_encyclopedia/src/utils/app_colors.dart';

import '../../resources/auth_methods.dart';
import '../models/user.dart' as model;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

late model.User gettdddd = const model.User(categories: [], email: '', isAccountDisabled: false, isContributor: false, password: '', phonenumber: '', subcategories: [], uid: '', username: '');
  @override
  void initState() {
    super.initState();
    AuthMethods().reloadCurrentCustomer();
   getCurrentUser();
  }

  getCurrentUser() async {
   gettdddd = await AuthMethods().getUserDetails();
   setState(() {
     
   });
   print('gettdddd : $gettdddd');
   inspect(gettdddd);
   print('1');
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40,),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal:  12.0),
                child: Text('User name', style: TextStyle(color: AppColors.primaryColor),),
              ),
              const SizedBox(height: 4,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:  12.0),
                child: Text(gettdddd.username.toString()),
              ),
              const SizedBox(height: 20,),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal:  12.0),
                child: Text('Email', style: TextStyle(color: AppColors.primaryColor),),
              ),
              const SizedBox(height: 4,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:  12.0),
                child: Text(gettdddd.email.toString()),
              ),
              const SizedBox(height: 20,),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal:  12.0),
                child: Text('Is Admin?', style: TextStyle(color: AppColors.primaryColor),),
              ),
              const SizedBox(height: 4,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:  12.0),
                child: Text(gettdddd.isContributor ? 'Yes' : 'No'),
              ),
              const SizedBox(height: 20,),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal:  12.0),
                child: Text('Phone Number', style: TextStyle(color: AppColors.primaryColor),),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:  12.0),
                child: Text(gettdddd.phonenumber.toString()),
              ),
            ],
          ),
        );
  }
}