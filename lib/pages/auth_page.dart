import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:login/pages/home_page.dart';
import 'package:login/pages/login_or_register_page.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return SecondPage();
          } else {
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
