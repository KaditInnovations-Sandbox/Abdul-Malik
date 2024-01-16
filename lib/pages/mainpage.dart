import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Mainview extends StatefulWidget {
  const Mainview({Key? key}) : super(key: key);

  @override
  State<Mainview> createState() => _MainviewState();
}

class _MainviewState extends State<Mainview> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  Future<void> _sendDataToApi() async {
    final String apiUrl = 'http://localhost:8080/api/v1/employees'; // Replace with your API endpoint

    final Dio dio = Dio();

    try {
      final Response response = await dio.post(
        apiUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
        data: {
          'emailId': emailController.text,
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
        },
      );

      if (response.statusCode == 201) {
        // Data sent successfully, handle the response if needed
        print('Data sent successfully');
      } else {
        // Handle errors here
        print('Failed to send data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle Dio errors here
      print('Error sending data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your App Title'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (emailController.text.isNotEmpty &&
                    firstNameController.text.isNotEmpty &&
                    lastNameController.text.isNotEmpty) {
                  _sendDataToApi();
                } else {
                  // Handle empty fields
                  print('Please fill in all fields');
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
