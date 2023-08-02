import 'package:demo_firebase_chat/auth/auth_screen.dart';
import 'package:demo_firebase_chat/constant.dart';
import 'package:demo_firebase_chat/models/auth_models.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
 final UsersModel? usersModel;
   const MyHomePage({super.key, this.usersModel});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    print("user Id :: $userId");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("homePage"),
        actions: [IconButton(onPressed: () => Authentication.signOut(context: context), icon: const Icon(Icons.logout))],
        leading: const SizedBox(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}