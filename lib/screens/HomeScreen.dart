import 'package:flutter/material.dart';
import 'package:flutter_dog_ceo/screens/DogScreen.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/Constants.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({super.key, required this.title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String imageUrl = "";

  bool isLoading = false;

  String errorMessage = '';

  // Function to fetch the dog image
  Future<void> fetchDogImage() async {
    setState(() {
      isLoading = true; // Start loading when network call begins
      errorMessage = ''; // Reset previous error message
    });

    try {
      final response = await http.get(Uri.parse(Constants.BASE_URL + Constants.RANDOM_DOG_IMAGE));

      if (response.statusCode == 200) {

        final Map<String, dynamic> data = json.decode(response.body);

        setState(() {
          imageUrl = data['message'];
          isLoading = false; // Stop loading once the image is fetched
        });

      } else {
        throw Exception("Failed to load image");
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: $error'; // Display the error message
      });
    }
  }

  // Function to handle refresh when user pulls or clicks refresh icon
  Future<void> _handleRefresh() async {
    await fetchDogImage();
  }

  @override
  void initState() {
    super.initState();
    fetchDogImage(); // Fetch image on initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _handleRefresh,
          ),
        ],
      ),
      drawer: Drawer(
          child:ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.only(top: 40),
            children: [
              ListTile(
                title: const Text('Home Screen'),
                onTap: () {

                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreen(title: 'Home')),
                  );

                },
              ),
              ListTile(
                title: const Text('Dog Screen'),
                onTap: () {

                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DogScreen(title: 'Dog')),
                  );

                },
              ),
            ]
          )
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator() // Show loading spinner when fetching image
            : imageUrl.isNotEmpty
            ? Image.network(
          imageUrl,
          width: 300,
          height: 300,
          fit: BoxFit.cover,
        )
            : errorMessage.isNotEmpty
            ? Text(errorMessage, style: TextStyle(color: Colors.red)) // Show error message if any
            : Text("No image found"),
      ),
    );
  }
}