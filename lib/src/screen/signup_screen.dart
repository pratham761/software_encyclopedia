import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:software_encyclopedia/src/screen/login_screen.dart';
import 'package:software_encyclopedia/src/utils/app_colors.dart';

import '../../resources/auth_methods.dart';
import '../utils/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

// Test@1234

  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  registration() async {
    if (passwordController.text != "" && emailController.text != "" && userNameController.text != "" && phoneNumberController.text != "") {
      try {
        isLoading = true;
        setState(() {
          
        });
        String res = await AuthMethods().signUpUser(
        email: emailController.text,
        password: passwordController.text,
        username: userNameController.text,
        phonenumber: phoneNumberController.text,
      );
       if (res != "User created successfully") {
        if (!mounted) return;
        showSnackbar(res, context);
        isLoading = false;
        setState(() {
          
        });
      } else {
        if (!mounted) return;
        showSnackbar(
            "Verification link sent to ${emailController.text}", context);
        isLoading = false;
        setState(() {
          
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
      } on FirebaseAuthException catch (e) {
        isLoading = false;
        setState(() {
          
        });
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: AppColors.yellowColor,
            content: Text(
              'Password is too weak',
              style: TextStyle(fontSize: 20),
            ),
          ));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: AppColors.yellowColor,
            content: Text(
              'Account already exits',
              style: TextStyle(fontSize: 20),
            ),
          ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
        title: const Text(
          'Signup',
          style: TextStyle(color: AppColors.primaryColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: userNameController,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.primaryShadowColor,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    hintStyle: const TextStyle(color: AppColors.primaryColor),
                    hintText: "Username",
                    hintMaxLines: 1,
                    errorStyle:
                        const TextStyle(color: Colors.red, fontSize: 10.0)),
                maxLines: 1,
                onChanged: (value) {
                  if (value.isEmpty) {}
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter username';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.primaryShadowColor,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    hintStyle: const TextStyle(color: AppColors.primaryColor),
                    hintText: "Email",
                    hintMaxLines: 1,
                    errorStyle:
                        const TextStyle(color: Colors.red, fontSize: 10.0)),
                maxLines: 1,
                onChanged: (value) {
                  if (value.isEmpty) {}
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: phoneNumberController,
                obscureText: false,
                keyboardType: TextInputType.number,
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.primaryShadowColor,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    hintStyle: const TextStyle(color: AppColors.primaryColor),
                    hintText: "Phone number",
                    hintMaxLines: 1,
                    errorStyle:
                        const TextStyle(color: Colors.red, fontSize: 10.0)),
                maxLines: 1,
                onChanged: (value) {
                  if (value.isEmpty) {}
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                keyboardType: TextInputType.text,
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.primaryShadowColor,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    hintStyle: const TextStyle(color: AppColors.primaryColor),
                    hintText: "Password",
                    hintMaxLines: 1,
                    errorStyle:
                        const TextStyle(color: Colors.red, fontSize: 10.0)),
                maxLines: 1,
                onChanged: (value) {
                  if (value.isEmpty) {}
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width - 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primaryColor,
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.primaryColor),
                  foregroundColor:
                      MaterialStateProperty.all(AppColors.canvasColor),
                ),
                onPressed: () async {
                  if (!isLoading) {
                  registration();
                  }

                },
                child: isLoading ? CircularProgressIndicator(color: AppColors.canvasColor,) : Text('SIGN UP'),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },
              child: const Text(
                'Already User? Login here',
                style: TextStyle(color: AppColors.primaryColor, fontSize: 15.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
