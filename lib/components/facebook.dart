import 'package:flutter/material.dart';

class FacebookImage extends StatelessWidget {
  const FacebookImage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),color: Colors.white),
          child: Image.asset("lib/images/facebook.png",height: 90,width: 90,),
          
      ),
    );
  }
}