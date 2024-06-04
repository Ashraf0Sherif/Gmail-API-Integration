import 'dart:convert';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart';

class CustomFirebase {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[GmailApi.gmailSendScope],
  );

  CustomFirebase() {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (account != null) {
        print('User signed in: ${account.email}');
      } else {
        print('User signed out');
      }
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google Sign-In aborted.');
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
  }

  Future<void> sendMessage(
      {required String toEmail,
      required String title,
      required String body}) async {
    var httpClient = await _googleSignIn.authenticatedClient();
    if (httpClient == null) {
      print('Failed to get authenticated client.');
      return;
    }

    var gmailApi = GmailApi(httpClient);

    var email = 'From: "me"\n'
        'To: $toEmail\n'
        'Subject: $title\n'
        '\n'
        '$body';

    var base64Email = base64UrlEncode(utf8.encode(email));

    var message = Message(raw: base64Email);
    await gmailApi.users.messages.send(message, 'me');
  }
}
