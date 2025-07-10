
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const MyButton({super.key,required this.onTap,required this.text});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap,child: Container(
      decoration: BoxDecoration(color: Colors.amber,borderRadius: BorderRadius.circular(25)),
      height: 40,
      width: 200,
      child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text(text), SizedBox(width: 5,),Icon(Icons.login)]),
    ));
  }
}
