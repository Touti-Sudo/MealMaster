import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/pages/auth_page.dart';
import 'package:login/pages/favorite_page.dart';
import 'package:login/pages/login_or_register_page.dart';
import 'package:login/pages/profile.dart';
import 'package:login/pages/register.dart';
import 'package:login/pages/security.dart';
import 'package:login/pages/theme_page.dart';
import 'package:provider/provider.dart';
import 'package:login/pages/login_page.dart';
import 'package:login/pages/home_page.dart';
import 'package:login/pages/settings_page.dart';
import 'package:login/theme/providertheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

Future<void> ensureAuthLoaded() async {
  while (FirebaseAuth.instance.currentUser == null &&
      FirebaseAuth.instance.authStateChanges() == null) {
    await Future.delayed(const Duration(milliseconds: 100));
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final rememberMe = prefs.getBool('remember_me') ?? false;

  if (!rememberMe) {
    await FirebaseAuth.instance.signOut();
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => Themeprovider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
      theme: Provider.of<Themeprovider>(context).themeData,
      routes: {
        '/secondpage': (context) => SecondPage(),
        '/loginpage': (context) => LoginPage(),
        '/settingspage': (context) => SettingsPage(),
        '/profilepage': (context) => ProfilePage(),
        '/registerpage':(context)=> RegisterPage(),
        '/logorreg':(context)=> LoginOrRegisterPage(),
        '/securitypage':(context)=> SecurityPage(),
        '/themepage':(context)=> ThemePage(),
        '/favorites': (context) => FavoritesPage(),
     },
    );
  }
}
