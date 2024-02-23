import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tec_admin/Presentation/widgets/EmailforOtp.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool isEmail(String input) {
    final emailRegex =
    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(input);
  }

  bool isPhoneNumber(String input) {
    final phoneNumberRegex = RegExp(r'^\d{10}$');
    return phoneNumberRegex.hasMatch(input);
  }

  bool isPasswordVisible = false;
  bool rememberMe = false;

  final Dio dio = Dio();

  void _email() async {
    final String username = usernameController.text;
    final String password = passwordController.text;

    try {
      const String apiUrl =
          'http://localhost:8081/travelease/AdminEmaillogin';

      Map<String, dynamic> adminData = {
        "admin_email": username,
        "admin_password": password,
      };

      final Response response = await dio.post(
        apiUrl,
        data: adminData,
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
      } else {
        print('Error: ${response.statusCode} - ${response.statusMessage}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _phone() async {
    try {
      final Response response = await dio.post(
        'http://localhost:8081/travelease/AdminPhonelogin',
        data: {
          "admin_phone": usernameController.text,
          "admin_password": passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
      } else {
        print('Error: ${response.statusCode} - ${response.statusMessage}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.black87, Colors.grey],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: MediaQuery.of(context).size.width * 0,
              bottom: MediaQuery.of(context).size.height * 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 1.25,
                child: Image.asset(
                  "assets/bus.png",
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.1,
              bottom: MediaQuery.of(context).size.height * 0.05,
              child: Container(
                width: MediaQuery.of(context).size.width / 3.5,
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 15,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 45.0, right: 45),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 9),
                      Center(
                        child: Image.asset(
                          "assets/logo.png",
                          height: MediaQuery.of(context).size.height / 5,
                          width: MediaQuery.of(context).size.width / 5,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 13),
                      const Text(
                        'Email or Phone Number',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: usernameController,
                        onEditingComplete: () {
                          if (isEmail(usernameController.text) ||
                              isPhoneNumber(usernameController.text)) {
                            // Check if email or phone, then call the appropriate method
                            if (isEmail(usernameController.text)) {
                              _email();
                            } else {
                              _phone();
                            }
                          } else {
                            print('Invalid email or phone number format');
                          }
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade300,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Password',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        onEditingComplete: () {
                          if (isEmail(usernameController.text) ||
                              isPhoneNumber(usernameController.text)) {
                            // Check if email or phone, then call the appropriate method
                            if (isEmail(usernameController.text)) {
                              _email();
                            } else {
                              _phone();
                            }
                          } else {
                            print('Invalid email or phone number format');
                          }
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade300,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
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
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Checkbox(
                            value: rememberMe,
                            onChanged: (bool? value) {
                              setState(() {
                                rememberMe = value!;
                              });
                            },
                            checkColor: Colors.black,
                            activeColor: Colors.orange,
                          ),
                          const Text(
                            'Remember me',
                            style: TextStyle(color: Colors.orange),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const Email();
                                },
                              );
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (isEmail(usernameController.text) ||
                                isPhoneNumber(usernameController.text)) {
                              // Check if email or phone, then call the appropriate method
                              if (isEmail(usernameController.text)) {
                                _email();
                              } else {
                                _phone();
                              }
                            } else {
                              print('Invalid email or phone number format');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            minimumSize: Size(
                              MediaQuery.of(context).size.width / 2.8 - 90,
                              50,
                            ),
                          ),
                          child: const Text('Login'),
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
