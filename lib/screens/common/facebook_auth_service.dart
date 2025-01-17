import 'dart:io';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FacebookAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final OAuthCredential credential;
        if(Platform.isIOS){
          credential = OAuthProvider('facebook.com').credential(
            idToken: result.accessToken!.token,
          );
        }else {
          credential = FacebookAuthProvider.credential(result.accessToken!.token);
        }

        UserCredential userCredential = await _auth.signInWithCredential(credential);
        return userCredential.user;
      } else if (result.status == LoginStatus.cancelled) {
        throw Exception("Login cancelled by user.");
      } else {
        throw Exception("Facebook login failed: ${result.message}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
