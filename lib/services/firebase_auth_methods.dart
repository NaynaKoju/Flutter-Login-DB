// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:acs_auth/screens/home_screen.dart';
import 'package:acs_auth/screens/login_email_password_screen.dart';
import 'package:acs_auth/utils/show_snackbar.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  User? get user => _auth.currentUser;

  Stream<User?> get authState => FirebaseAuth.instance.userChanges();

  final String defaultErrorMsg = "Some Error Occured";

  // EMAIL SIGN UP
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      sendEmailVerification(context);

      signOut(context);

      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          EmailPasswordLogin.routeName,
          (Route<dynamic> route) => false,
        );
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(
        context,
        e.message ?? defaultErrorMsg,
      );
    }
  }

  // EMAIL LOGIN
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          HomeScreen.routeName,
          (Route<dynamic> route) => false,
        );
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message ?? defaultErrorMsg);
    }
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, 'Email verification sent!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message ?? defaultErrorMsg);
    }
  }

  Future<void> changePassword(BuildContext context) async {
    //
  }

  // GOOGLE SIGN IN
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        await _auth.signInWithCredential(credential);

        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            HomeScreen.routeName,
            (Route<dynamic> route) => false,
          );
        });
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message ?? defaultErrorMsg);
    }
  }

  // SIGN OUT
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();

      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          EmailPasswordLogin.routeName,
          (Route<dynamic> route) => false,
        );
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message ?? defaultErrorMsg);
    }
  }

  // REMOVE ACCOUNT
  Future<void> removeAccount(BuildContext context) async {
    try {
      _auth.currentUser!.delete();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          EmailPasswordLogin.routeName,
          (Route<dynamic> route) => false,
        );
      });

      DateTime.now().microsecondsSinceEpoch;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message ?? defaultErrorMsg);
    }
  }
}
