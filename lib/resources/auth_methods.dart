import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:software_encyclopedia/src/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  // Sign up the user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String phonenumber,
  }) async {
    String result = 'Some error occured';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          phonenumber.isNotEmpty) {
        // register user to firebase
        UserCredential createdUserCredentials = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);


        // User model
        model.User user = model.User(
          email: email,
          uid: createdUserCredentials.user!.uid,
          username: username,
          password: password,
          phonenumber: phonenumber,
          isContributor: false,
          isAccountDisabled: false,
          categories: [],
          subcategories: [],
        );
        // add user to our db
        await _firestore
            .collection('users')
            .doc(createdUserCredentials.user!.uid)
            .set(user.toJson());
        createdUserCredentials.user?.sendEmailVerification();
        result = 'User created successfully';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        result = 'Email not valid';
      } else if (err.code == 'weak-password') {
        result = 'Password length is weak';
      } else if (err.code == 'email-already-in-use') {
        result = 'Email is already exits';
      } else if (err.code == 'operation-not-allowed') {
        result = 'Account is disabled by admin';
      }
    } catch (err) {
      result = err.toString();
    }

    return result;
  }

  // Login User
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String result = 'Some error occured';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        bool isEmailVerified = _auth.currentUser!.emailVerified;
        if (isEmailVerified) {
          result = "success";
        } else {
          result = 'Check email to verify';
        }
      } else {
        result = 'Enter all fields';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        result = 'Email not valid';
      } else if (err.code == 'user-not-found') {
        result = 'Account not found';
      } else if (err.code == 'wrong-password') {
        result = 'Invalid password';
      } else if (err.code == 'user-disabled') {
        result = 'Account is disabled by admin';
      } else if (err.code == 'INVALID_LOGIN_CREDENTIALS') {
        result = 'Invalid login credentials';
      }
    } catch (error) {
      result = error.toString();
    }
    return result;
  }

  Future<String> reloadCurrentCustomer() async {
    dynamic res = '';
    await FirebaseAuth.instance.currentUser!.reload();
    res = FirebaseAuth.instance.currentUser!.uid;
    print('RELOADDDID $res');
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}