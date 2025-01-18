import 'package:flutter/material.dart';

class DogScreen extends StatefulWidget {

  final String title;

  const DogScreen({super.key, required this.title});

  @override
  State<DogScreen> createState() => _DogScreenState();
}

class _DogScreenState extends State<DogScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title)
      ),
      body: Center(
        child: Text(widget.title),
      ),
    );
  }
}
