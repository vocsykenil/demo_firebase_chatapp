import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_firebase_chat/constant.dart';
import 'package:demo_firebase_chat/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Future<void> _handleSignIn() async {
  //   try {
  //     GoogleSignInAccount? account = await _googleSignIn.signIn();
  //     if (account != null) {
  //       // Successfully signed in, you can now access the user information
  //       print("User Email: ${account.email}");
  //       print("User Display Name: ${account.displayName}");
  //       print("User Photo URL: ${account.photoUrl}");
  //       final GoogleSignInAuthentication googleSignInAuthentication = await account.authentication;
  //       final AuthCredential authCredential =
  //           GoogleAuthProvider.credential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
  //
  //       // Getting users credential
  //       UserCredential result = await auth.signInWithCredential(authCredential);
  //       User? user = result.user;
  //       DocumentSnapshot userExist = await firebaseFirestore.collection('users').doc(user?.uid).get();
  //       if(userExist.exists){
  //         print("user already exist in database");
  //       }else{
  //         await firebaseFirestore.collection('users').doc(user?.uid).set({
  //           'email':account.email,
  //           'image':account.photoUrl,
  //           'name':account.displayName,
  //           'uid':user?.uid,
  //           'timestamp':DateTime.now(),
  //         });
  //
  //         Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(),));
  //       }
  //     }
  //     //   if(user != null){
  //     //
  //     //
  //     //   // print("uid :: ${user?.uid}");
  //     // } else {
  //     //   // User canceled the sign-in process
  //     //   print("Sign-in process canceled.");
  //     // }
  //   } catch (error) {
  //     // Handle the error
  //     print("Error while signing in: $error");
  //   }
  //   setState(() {
  //
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ElevatedButton.icon(
            onPressed: () {
              Authentication.signInWithGoogle(context: context);
            },
            icon: const Icon(Icons.mail),
            label: const Text('Sign In With google')),
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
        if(userId.isEmpty){
          userId = user?.uid??"";
        }
        DocumentSnapshot userExist = await firebaseFirestore.collection('users').doc(user?.uid).get();
        if (userExist.exists) {
          print("user already exist in database");
        } else {
          await firebaseFirestore.collection('users').doc(user?.uid).set({
            'email': googleSignInAccount.email,
            'image': googleSignInAccount.photoUrl,
            'name': googleSignInAccount.displayName,
            'uid': user?.uid,
            'timestamp': DateTime.now(),
          });
        }
       Get.to(()=>const MyHomePage());
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
      if(userId.isNotEmpty){
        userId = '';
      }
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
      style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
    ),
  );
}
