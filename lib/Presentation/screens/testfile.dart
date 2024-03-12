import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tec_admin/Data/Models/Loginmodel.dart';
import 'package:tec_admin/Data/Repositories/Login_repo.dart';
import 'package:tec_admin/Presentation/widgets/EmailforOtp.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserRepository loginRepository = UserRepository();

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



  Future<void> _login() async {
    final String email = usernameController.text;
    final String password = passwordController.text;

    final UserModel user = UserModel(username: email, password: password);
    final bool success = await UserRepository().login(user);

    if (success) {
      Navigator.pushNamed(context, '/home');
    } else {
      print('Login failed');
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
                        onEditingComplete: _login,
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
                        onEditingComplete: _login,
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
                          onPressed: _login,
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
