import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freelancing/firebase/custom_firebase.dart';

import '../firebase/firebase_exceptions.dart';
import '../firebase/firebase_result.dart';

class MyRepo {
  CustomFirebase customFirebase;

  MyRepo(this.customFirebase);

  Future<FirebaseResult<UserCredential>> signInWithGoogle() async {
    try {
      UserCredential credential = await customFirebase.signInWithGoogle();
      return FirebaseResult.success(credential);
    } catch (error) {
      return FirebaseResult.failure(
          FirebaseExceptions.getFirebaseException(error));
    }
  }

  Future<FirebaseResult<dynamic>> signOut() async {
    try {
      await customFirebase.signOut();
      return const FirebaseResult.success(null);
    } catch (error) {
      return FirebaseResult.failure(
          FirebaseExceptions.getFirebaseException(error));
    }
  }

  Future<FirebaseResult<dynamic>> sendMessage(
      {required String toEmail,
      required String title,
      required String body,
      File? attachment}) async {
    try {
      await customFirebase.sendMessage(
          toEmail: toEmail, title: title, body: body, attachment: attachment);
      return const FirebaseResult.success(null);
    } catch (error) {
      return FirebaseResult.failure(
          FirebaseExceptions.getFirebaseException(error));
    }
  }
}
