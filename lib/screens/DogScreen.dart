import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/Dog.dart';
import '../utils/Constants.dart';


class DogScreen extends StatefulWidget {

  final String title;

  const DogScreen({super.key, required this.title});

  @override
  State<DogScreen> createState() => _DogScreenState();
}

class _DogScreenState extends State<DogScreen> {

  Dog? dog;
  bool isLoading = false;

  Future<void> fetchDogImage() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(Constants.BASE_URL + Constants.RANDOM_DOG_IMAGE));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        setState(() {
          dog = Dog.fromJson(data);
        });
      } else {
        throw Exception("Failed to load image");
      }
    } catch (e) {
      // Optionally handle error here
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDogImage();
  }

  Future<void> _handleRefresh() async {
    await fetchDogImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: (){
              _handleRefresh();
            },
          ),
        ],
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : dog != null
            ? Image.network(
          dog!.message,
          width: 300,
          height: 300,
          fit: BoxFit.cover,
        )
            : Text('Failed to load image'),
      ),
    );
  }
}