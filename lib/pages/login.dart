import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testapp/pages/mainpage.dart';


class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> attemptLogin(BuildContext context) async {
    final String username = usernameController.text;
    final String password = passwordController.text;

    final String loginEndpoint = 'http://localhost:3000/users/login';

    try {
      final http.Response response = await http.post(
        Uri.parse(loginEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        // Successful login
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Mainview()),
        );
      } else if (response.statusCode == 401) {
        // Unauthorized: Invalid credentials
        print('Invalid credentials');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid Credentials'),
              content: Text('Please check your username and password.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Handle other error cases
        print('Error during login: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors or other exceptions
      print('Error during login: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Image.asset(
            'assets/vector.png',
            height: 689,
          ),
          SizedBox(width: 550,),
          Column(
            children: [
              SizedBox(height: 180,),
              Image.asset(
                'assets/mark.png',
                height: 60,
              ),
              SizedBox(height: 35.0),
              Container(
                width: 350,
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.fromLTRB(140.0, 10.0, 20.0, 10.0),
                    hintText: "Username",
                    hintStyle: TextStyle(color: Colors.orange),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                width: 350,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.fromLTRB(140.0, 10.0, 20.0, 10.0),
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.orange),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  attemptLogin(context);
                },
                child: Text('Login'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
