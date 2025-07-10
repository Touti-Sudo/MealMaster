import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:login/components/facebook.dart';
import 'package:login/components/google.dart';
import 'package:login/components/my_button.dart';

class LoginPage extends StatefulWidget {
  final void Function()? ontap;
  const LoginPage({Key? key, this.ontap}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> _showErrorDialog(String title, String message) async {
    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        icon: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Icon(Icons.error_outline, size: 40)],
        ),
        shadowColor: Colors.black,

        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  void _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      rememberMe = prefs.getBool('remember_me') ?? true;
    });
  }

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final resetpasswordcontroller = TextEditingController();
  bool rememberMe = true;

  void _submit() async {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return;
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      Navigator.of(context).pop();

      if (e.code == "user-not-found") {
        await _showErrorDialog(
          "No email found",
          "We couldn't find an account with this email.",
        );
      } else if (e.code == "wrong-password") {
        await _showErrorDialog(
          "Incorrect password",
          "Please check your password and try again.",
        );
      } else {
        await _showErrorDialog(
          "Error",
          "Please check your email and password.",
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      await _showErrorDialog("Error", e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    void restpassword() async {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: TextField(controller: resetpasswordcontroller),
          title: Text("Enter your email adresse"),
          actions: [
            GestureDetector(
              onTap: () async {
                await FirebaseAuth.instance.sendPasswordResetEmail(
                  email: resetpasswordcontroller.text.trim(),
                );
                Navigator.of(context).pop();
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Text(
                      'An email has been sent to your inbox. Follow the instructions to reset your password.',
                    ),
                  ),
                );
              },
              child: Text('Ok'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              width: 300,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Image.asset("lib/images/icon.png", height: 150),
                  Text(
                    "Login",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      style: TextStyle(color: Colors.grey),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        prefixIcon: Icon(Icons.person_outline),
                        filled: true,
                        fillColor: Colors.grey[200],
                        prefixIconColor: Colors.grey,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          style: TextStyle(color: Colors.grey),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Password';
                            }
                            return null;
                          },
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            prefixIcon: Icon(Icons.lock, color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: rememberMe,
                            onChanged: (bool? newValue) async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              setState(() {
                                rememberMe = newValue ?? true;
                              });
                              await prefs.setBool('remember_me', rememberMe);
                            },

                            checkColor: Colors.white,
                            activeColor: Colors.amber,
                          ),
                          Text("Remember me"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: restpassword,
                            child: Text(
                              style: TextStyle(color: Colors.grey),
                              "Forget password",
                            ),
                          ),
                        ],
                      ),
                      //MYBUTTON
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: MyButton(onTap: _submit, text: "Sign in"),
                          ),
                        ],
                      ),

                      SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Not a member?",
                            style: TextStyle(color: Colors.grey),
                          ),
                          GestureDetector(
                            onTap: widget.ontap,
                            child: Text(
                              "Sign up now !",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 2.5,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      Text(
                        "Or continue with",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 2.5,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [GoolgeImage(), FacebookImage()],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
