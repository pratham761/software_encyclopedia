import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:software_encyclopedia/src/screen/dashboard_screen.dart';
import 'package:software_encyclopedia/src/utils/app_colors.dart';
import 'package:software_encyclopedia/src/utils/app_strings.dart';

import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  void initState() {
    super.initState();
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
              height: MediaQuery.of(context).size.height * 0.20,
              child: Container(
                color: Colors.grey[100],
                child: Center(
                  child: Text('Top Logo'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.primaryShadowColor,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10)),
                  hintStyle: TextStyle(color: AppColors.primaryColor),
                  hintText: "Email",
                  hintMaxLines: 1,
                  errorStyle: TextStyle(color: Colors.red, fontSize: 10.0)
                ),
                maxLines: 1,
                onChanged: (value) {
                  print('On CHange value : $value');
                  if (value.isEmpty) {
                    print('On Change Value Empty');
                  }
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  
                  filled: true,
                  fillColor: AppColors.primaryShadowColor,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10)),
                  hintStyle: TextStyle(color: AppColors.primaryColor),
                  hintText: "Password",
                  hintMaxLines: 1,
                  errorStyle: TextStyle(color: Colors.red, fontSize: 10.0)
                ),
                maxLines: 1,
                onChanged: (value) {
                  print('On CHange value : $value');
                  if (value.isEmpty) {
                    print('On Change Value Empty');
                  }
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20.0,),
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width - 24,
              
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primaryColor,
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
                  foregroundColor: MaterialStateProperty.all(AppColors.canvasColor),
                ),
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('appIsLoggedIn', true);
                prefs.reload();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
              
              }, child: Text('LOGIN'),),
            ),
            const SizedBox(height: 10.0,),
            TextButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
              child: Text(AppStrings.newUserLabelString, style: TextStyle(color: AppColors.primaryColor, fontSize: 15.0),),
            ),
            const SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 3.8,
                  height: 2,
                  color: AppColors.primaryColor,
                ),
                Text('OR', style: TextStyle(fontSize: 15.0, color: AppColors.primaryColor)),
                Container(
                  width: MediaQuery.of(context).size.width / 3.8,
                  height: 2,
                  color: AppColors.primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
