import 'package:flutter/material.dart';

class SlidingBottomBar extends StatelessWidget {
  const SlidingBottomBar({
    required this.child,
    required this.controller,
    required this.visible,
  });

  final Widget child;
  final AnimationController controller;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    visible ? controller.reverse() : controller.forward();
    return SlideTransition(
      position:
          Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1)).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
      ),
      child: child,
    );
  }
}
