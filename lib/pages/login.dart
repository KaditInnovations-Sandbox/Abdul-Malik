import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:testapp/pages/mainpage.dart';
import 'package:testapp/widgets/EmailforOtp.dart';

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


  Future<void> attemptLogin(BuildContext context) async {
    final String username = usernameController.text;
    final String password = passwordController.text;


    const String loginEndpoint = 'http://localhost:8081/travelease/Adminlogin';

    try {
      FormData formData = FormData();


      if (isEmail(username)) {
        formData.fields.addAll([
          MapEntry('adminLogin.admin_email', username),
          MapEntry('adminLogin.admin_password', password),
          const MapEntry('key', 'email'),
        ]);
      } else {
        formData.fields.addAll([
          MapEntry('adminLogin.admin_phone', username),
          MapEntry('adminLogin.admin_password', password),
          const MapEntry('key', 'phone'),
        ]);
      }

      print('FormData.fields: ${formData.fields}');
      print('FormData.files: ${formData.files}');

      final Response response = await dio.post(
        loginEndpoint,
        data: formData,

      );


      if (rememberMe) {
        // Save credentials securely if Remember Me is checked
        await _storage.write(key: 'username', value: username);
        await _storage.write(key: 'password', value: password);
      }
      if (response.statusCode == 200 && response.data != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage(name: '${response.data}',)),
        );
        print('Login Succesful');
        print('Username: ${response.data}');
      } else if (response.statusCode == 401) {
        print('Invalid credentials');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Invalid Credentials'),
              content: const Text('Please check your username and password.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
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
      if (error is DioError) {
        print('DioError: ${error.message}');
        if (error.response != null) {
          print('Response data: ${error.response?.data}');
        }
      }
      else{
        print('Error during login: $error');
      }
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

                            attemptLogin(context);
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

                            attemptLogin(context);
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

                              attemptLogin(context);
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
