import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:software_encyclopedia/src/utils/app_colors.dart';
import 'package:software_encyclopedia/src/utils/app_strings.dart';

import '../../resources/auth_methods.dart';
import '../utils/utils.dart';
import 'home_view.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  loginUser() async {
    try {
      isLoading = true;
      setState(() {
        
      });
      String res = await AuthMethods().loginUser(
        email: emailController.text,
        password: passwordController.text,
      );

      if (res == "success") {
        if (!mounted) return;
        FocusScope.of(context).unfocus();
        isLoading = false;
        setState(() {
          
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('appIsLoggedIn', true);
        prefs.reload();

        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const HomeView(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: AppColors.successColor,
          content: Text(
            'Login successfully',
            style: TextStyle(fontSize: 20),
          ),
        ));
      } else {
        isLoading = false;
        setState(() {
          
        });
        if (!mounted) return;
        showSnackbar(res, context);
      }
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      setState(() {
        
      });
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: AppColors.yellowColor,
          content: Text(
            'No user found for that email',
            style: TextStyle(fontSize: 20),
          ),
        ));
      } else if (e.code == "wrong-password") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: AppColors.yellowColor,
          content: Text(
            'Wrong password provided for that user',
            style: TextStyle(fontSize: 20),
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvasColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.10,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.30,
              child: Lottie.asset('assets/animation/softencyclopedia.json'),
            ),
            const SizedBox(
              height: 20.0,
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
                  errorStyle: const TextStyle(
                    color: Colors.red,
                    fontSize: 10.0,
                  ),
                ),
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
                controller: passwordController,
                obscureText: true,
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
                  hintText: "Password",
                  hintMaxLines: 1,
                  errorStyle: const TextStyle(
                    color: Colors.red,
                    fontSize: 10.0,
                  ),
                ),
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
loginUser();
                  }
                  
                },
                child: isLoading ? CircularProgressIndicator(color: AppColors.canvasColor,) : Text('LOGIN'),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpScreen(),
                  ),
                );
              },
              child: Text(
                AppStrings.newUserLabelString,
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 15.0,
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Container(
          //         width: MediaQuery.of(context).size.width / 3.8,
          //         height: 2,
          //         color: AppColors.primaryColor,
          //       ),
          //       const Text(
          //         'OR',
          //         style: TextStyle(
          //           fontSize: 15.0,
          //           color: AppColors.primaryColor,
          //         ),
          //       ),
          //       Container(
          //         width: MediaQuery.of(context).size.width / 3.8,
          //         height: 2,
          //         color: AppColors.primaryColor,
          //       ),
          //     ],
          //   ),
          // ],
          ],
        ),
      ),
    );
  }
}
