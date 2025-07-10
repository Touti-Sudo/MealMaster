import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/components/facebook.dart';
import 'package:login/components/google.dart';
import 'package:login/components/my_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
  final _confirmepasswordController = TextEditingController();
  bool rememberMe = true;

void _submit() async {
  if (!mounted) return;

  if (!_formKey.currentState!.validate()) {
    return;
  }


  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  try {
    if (_passwordController.text != _confirmepasswordController.text) {
      if (!mounted) return;
      Navigator.of(context).pop(); 
      await _showErrorDialog(
        "Passwords don't match",
        "Please confirm your password!",
      );
      return;
    }

    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) return;
    Navigator.of(context).pop(); 

  
    Navigator.pushReplacementNamed(context, "/secondpage");

  } on FirebaseAuthException catch (e) {
    if (!mounted) return;
    Navigator.of(context).pop();

    if (e.code == "email-already-in-use") {
      await _showErrorDialog(
        "Email already in use",
        "An account already exists with this email.",
      );
    } else if (e.code == "invalid-email") {
      await _showErrorDialog(
        "Invalid email",
        "Please enter a valid email address.",
      );
    } else if (e.code == "weak-password") {
      await _showErrorDialog(
        "Weak password",
        "The password must be 6 characters long or more.",
      );
    } else {
      await _showErrorDialog(
        "Error",
        "An unexpected error occurred. (${e.message})",
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
                  Image.asset('lib/images/icon.png'),

                  Text(
                    "Sign up",
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
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          style: TextStyle(color: Colors.grey),
                          controller: _confirmepasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Confirme your password",
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
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: MyButton(onTap: _submit, text: "Sign up"),
                          ),
                        ],
                      ),

                      SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account ?",
                            style: TextStyle(color: Colors.grey),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "/logorreg");
                            },
                            child: Text(
                              "Sign in now !",
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
