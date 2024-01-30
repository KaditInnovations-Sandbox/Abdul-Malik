import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewPassword extends StatefulWidget {
  final String email;

  NewPassword({required this.email});

  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController reEnterPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter Your New Password '),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.key, size: 50, color: Colors.orange),
            SizedBox(height: 10),
            Text('Enter Your New Password'),
            SizedBox(height: 10),
            TextFormField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'New Password'),
              onEditingComplete: () {},
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: reEnterPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Re-enter Password'),
              onEditingComplete: () {},
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _changePassword();
                  },
                  child: Text('Change Password'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }

  void _changePassword() {
    String newPassword = newPasswordController.text;
    String reEnteredPassword = reEnterPasswordController.text;

    if (newPassword == reEnteredPassword) {
      // Passwords match, proceed with API call
      _sendEmailAndPasswordToApi(widget.email, newPassword);
    } else {
      // Passwords don't match, show an error or alert the user
      // You can display an error message, e.g., using a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _sendEmailAndPasswordToApi(String email, String password) async {
    String apiUrl = "http://localhost:8081/travelease/updatePassword"; // Replace with your API endpoint

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // API call successful
        print("Response data: ${response.body}");
        print("Password Changes Successfully");

        Navigator.of(context).pop();
        // Handle the API response as needed
      } else {
        // API call failed
        print("API call failed with status code: ${response.statusCode}");
        print("Response data: ${response.body}");
        // Handle the API error as needed
      }
    } catch (e) {
      // Handle any exceptions that occur during the API call
      print("Error during API call: $e");
      // Handle the exception as needed
    }
  }
}
