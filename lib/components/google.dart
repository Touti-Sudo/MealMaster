import 'package:flutter/material.dart';
import 'package:login/services/auth_service.dart';


class GoolgeImage extends StatelessWidget {
  const GoolgeImage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),color: Colors.white),
        child: Image.asset("lib/images/google.png",height: 90,width: 90,),
      ),
      onTap: () => AuthService().signinWithGoogle(),
    );
  }
}