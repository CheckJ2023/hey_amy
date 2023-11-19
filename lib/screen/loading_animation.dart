import 'package:flutter/material.dart';

class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({super.key});

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        // color: Colors.green,
        color: Colors.black,
        // backgroundColor: Colors.amberAccent,
        backgroundColor: Colors.grey,
        strokeWidth: 2.0,
      ),
    );
  }
}
