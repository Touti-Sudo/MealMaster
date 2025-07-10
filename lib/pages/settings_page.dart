import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  bool value = true;
void connexion() async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    if (!mounted) return;
    Navigator.pop(context);

  } on FirebaseAuthException catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message ?? 'Login failed')),
    );
  }
}
void showlogin() async {
  if (!mounted) return;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        "We need to verify that it's really you who wants to delete the account. Please log in again.",
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(hintText: 'Enter your email address'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Enter your password'),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed:() async{
          await connexion;
          final user = FirebaseAuth.instance.currentUser;
          await user?.delete();
        }, child: const Text('Confirm')),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("lib/images/icon.png"),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: Container(
                width: double.infinity,
        
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: TextButton(
                  style: ButtonStyle(alignment: Alignment.centerLeft),
                  onPressed: () {
                    Navigator.pushNamed(context, '/profilepage');
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Account',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: Container(
                width: double.infinity,
        
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: TextButton(
                  style: ButtonStyle(alignment: Alignment.centerLeft),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/securitypage');
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.security,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Security',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: Container(
                width: double.infinity,
        
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: TextButton(
                  style: ButtonStyle(alignment: Alignment.centerLeft),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/themepage');
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.color_lens_rounded,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Theme',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.redAccent.withAlpha(200), Colors.redAccent.withAlpha(2)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
              width: double.infinity,
              height: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "DANGER ZONE",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: Container(
                width: double.infinity,
        
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: TextButton(
                  style: ButtonStyle(alignment: Alignment.centerLeft),
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    showlogin();
                    await user?.delete();
                    if (!mounted) return;
                    await Navigator.pushReplacementNamed(context, '/logorreg');
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_box_rounded,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Delete user',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        
          ],
        ),
      ),
    );
  }
}
