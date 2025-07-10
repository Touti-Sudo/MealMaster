import 'package:flutter/material.dart';
import 'package:login/pages/login_page.dart';
import 'package:login/pages/register.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  bool showloginpage=true;

  void togglePages() {
    setState(() {
      showloginpage=!showloginpage;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (showloginpage) {
      return LoginPage(ontap: togglePages);
    }else {
      return RegisterPage();
    }
  }
}