import 'package:flutter/material.dart';

class Transcripter extends StatefulWidget {
  const Transcripter({super.key});

  @override
  State<Transcripter> createState() => _TranscripterState();
}

class _TranscripterState extends State<Transcripter> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('I am transcripter'),
    );
  }
}
