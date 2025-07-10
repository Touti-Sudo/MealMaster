import 'package:flutter/material.dart';

class Emoji extends StatefulWidget {
  const Emoji({super.key});

  @override
  State<Emoji> createState() => _EmojiState();
}

class _EmojiState extends State<Emoji>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: -0.3,
      end: 0.3,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: const Text(
        '👋',
        style: TextStyle(fontSize: 30),
      ),
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value,
          origin: const Offset(0, 30),
          child: child,
        );
      },
    );
  }
}
