import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Google Sign-In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Step 1: Sign in with Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("User canceled Google Sign-In");
        return null; // User canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Step 2: Get the credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Step 3: Sign in with Firebase
      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      // Step 4: Save user details to Firestore
      await _saveUserToFirestore(userCredential.user);

      return userCredential;
    } catch (e) {
      print("Error during Google Sign-In: $e");
      return null;
    }
  }

  // Save user details to Firestore
  Future<void> _saveUserToFirestore(User? user) async {
    if (user == null) return;

    final docRef =
    FirebaseFirestore.instance.collection('trainees').doc(user.uid);

    final docSnapshot = await docRef.get();
    if (!docSnapshot.exists) {
      // Save user details to Firestore
      await docRef.set({
        'email': user.email,
        'name': user.displayName,
        'photoUrl': user.photoURL,
        'role': 'trainee',
        'createdAt': FieldValue.serverTimestamp(),
      });
      print("User saved to Firestore.");
    } else {
      print("User already exists in Firestore.");
    }
  }
}
