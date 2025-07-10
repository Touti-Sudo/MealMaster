import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  @override
  Widget build(BuildContext context) {
    void restpassword() async {
      final user = FirebaseAuth.instance.currentUser;
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: '${user!.email}');
        if (!mounted) return;
        showDialog(context: context, builder: (context)=> AlertDialog(content: Text('An email has been sent to your inbox. Follow the instructions to reset your password.'),) );

    }

    ;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/settingspage');
          },
        ),
        title: Text('Security'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
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
                style: ButtonStyle(alignment: Alignment.centerLeft,backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.surface)),
                onPressed: restpassword,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.key,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Reset Password',
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
    );
  }
}
