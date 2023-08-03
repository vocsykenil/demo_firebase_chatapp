import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_firebase_chat/constant.dart';
import 'package:demo_firebase_chat/home.dart';
import 'package:demo_firebase_chat/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network("https://play-lh.googleusercontent.com/cF_oWC9Io_I9smEBhjhUHkOO6vX5wMbZJgFpGny4MkMMtz25iIJEh2wASdbbEN7jseAx=w240-h480-rw"),
            ElevatedButton.icon(
                onPressed: () {
                  Authentication.signInWithGoogle(context: context);
                },
                icon: const Icon(Icons.mail),
                label: const Text('Sign In With google')),
          ],
        ),
      ),
    );
  }
}

class Authentication {
  /// sign in with google
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    // FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential = await auth.signInWithCredential(credential);

        user = userCredential.user;
        if(user?.uid != null){
          getPreference.write(PrefConst.userId, user?.uid);
        }
        DocumentSnapshot userExist = await firebaseFirestore.collection('users').doc(user?.uid).get();
        if (userExist.exists) {
          if (kDebugMode) {
            print("user already exist in database");
          }
        } else {
           await firebaseFirestore.collection('users').doc(user?.uid).set({
            'email': googleSignInAccount.email,
            'image': googleSignInAccount.photoUrl,
            'name': googleSignInAccount.displayName,
            'uid': user?.uid,
            'timestamp': DateTime.now(),
          });
        }
       Get.to(()=> MyHomePage());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    }

    return user;
  }

  /// sign out with google
  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
        getPreference.write(PrefConst.userId, '');
      Get.to(() => const AuthScreen());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }
}

SnackBar customSnackBar({required String content}) {
  return SnackBar(
    backgroundColor: Colors.black,
    content: Text(
      content,
      style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
    ),
  );
}
