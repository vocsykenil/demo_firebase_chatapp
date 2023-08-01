import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<void> _handleSignIn() async {
    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        // Successfully signed in, you can now access the user information
        print("User Email: ${account.email}");
        print("User Display Name: ${account.displayName}");
        print("User Photo URL: ${account.photoUrl}");
      } else {
        // User canceled the sign-in process
        print("Sign-in process canceled.");
      }
    } catch (error) {
      // Handle the error
      print("Error while signing in: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ElevatedButton.icon(onPressed:_handleSignIn, icon: const Icon(Icons.mail), label: const Text('Sign In With google')),
      ),
    );
  }
}
