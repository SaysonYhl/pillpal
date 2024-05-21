import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:pillpal/constants.dart';
import 'package:pillpal/pages/home_page.dart';
import 'package:pillpal/welcome_screens/login.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();



  //sign in with google
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      // Handle error
    }
  }

  ///sign in with email and password
  Future<void> signIn(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController) async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(context, e.code);
    }
  }

  void showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          title: Center(
            child: Text(
              message,
              style: const TextStyle(
                color: kErrorBorderColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  //sign up
  Future<void> signUp(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController,
      TextEditingController confirmPasswordController) async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    //create account
    try {
      //check password-confpass
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      } else {
        Navigator.pop(context);
        showErrorMessage(context, 'Password does not match');
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(context, e.code);
    }
    //logout method sa profile
  }

  //sign out
  Future<void> signOut(BuildContext context) async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
        (route) => false,
      );
    } catch (e) {
      print(e.toString());
      // Handle error
    }
  }
}
