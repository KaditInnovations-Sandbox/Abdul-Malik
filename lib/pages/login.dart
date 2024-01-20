import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testapp/pages/mainpage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isEmail(String input) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(input);
  }

  bool isPhoneNumber(String input) {
    final phoneNumberRegex = RegExp(r'^\d{8}$');
    return phoneNumberRegex.hasMatch(input);
  }


  bool isPasswordVisible = false;


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
          MaterialPageRoute(builder: (context) => MyHomePage()),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.black87, Colors.grey],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: MediaQuery.of(context).size.width / 55,
              bottom: MediaQuery.of(context).size.height * 0,
              child: Container(
                height: MediaQuery.of(context).size.height /1.25,
                child: Image.asset(
                  "assets/bus.png",
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width / 9.7,
              bottom: MediaQuery.of(context).size.height / 19,
              child: Container(
                width: MediaQuery.of(context).size.width / 2.8,
                height: MediaQuery.of(context).size.height / 1.25,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 15,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 45.0,right: 45,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/logo.png",
                          height: 180,
                          width: 180,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Email or Phone Number',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade400,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Password',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade400,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              // Toggle password visibility
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Checkbox(
                            value: false,
                            onChanged: (bool? value) {},
                            checkColor: Colors.black,
                            activeColor: Colors.orange,
                          ),
                          Text(
                            'Remember me',
                            style: TextStyle(color: Colors.orange),
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (isEmail(usernameController.text)) {
                              print("$usernameController");
                              print("$passwordController");
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MyHomePage()),
                              );
                            } else if (isPhoneNumber(usernameController.text)) {
                              print("$usernameController");
                              print("$passwordController");
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MyHomePage()),
                              );
                            } else {
                              print("$usernameController");
                              print("$passwordController");
                              print('Invalid email or phone number format');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            onPrimary: Colors.white,
                            minimumSize: Size(
                              MediaQuery.of(context).size.width / 2.8 - 90,
                              50,
                            ),
                          ),
                          child: Text('Login'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
