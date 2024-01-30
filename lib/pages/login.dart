import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:testapp/pages/mainpage.dart';
import 'package:testapp/widgets/EmailforOtp.dart';
import 'package:testapp/widgets/Forget_Password.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

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


    final String loginEndpoint = 'http://localhost:8081/travelease/Adminlogin';

    try {
      FormData formData = FormData();


      if (isEmail(username)) {
        formData.fields.add(
          MapEntry('adminLogin', jsonEncode({
            'admin_email': username,
            'admin_password': password,
          }),

          ),
        );
        formData.fields.add(
          MapEntry('key', 'email'),
        );

      } else {
        formData.fields.add(
          MapEntry('adminLogin', jsonEncode({
            'admin_phone': username,
            'admin_password': password,
          })),
        );

        formData.fields.add(
          MapEntry('key', 'phone'),
        );

      }

      print('FormData.fields: ${formData.fields}');
      print('FormData.files: ${formData.files}');

      final Response response = await dio.post(
        loginEndpoint,
        data: formData,
        options: Options(
          headers: {'Content-Type' : 'multipart/form-data'}
        )

      );


      if (rememberMe) {
        // Save credentials securely if Remember Me is checked
        await _storage.write(key: 'username', value: username);
        await _storage.write(key: 'password', value: password);
      }
      if (response.statusCode == 200) {
        // Successful login
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      } else if (response.statusCode == 401) {
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
              right: MediaQuery.of(context).size.width * 0,
              bottom: MediaQuery.of(context).size.height * 0,
              child: Container(
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
                      offset: Offset(0, 3),
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
                      Text(
                        'Email or Phone Number',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
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
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
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
                      SizedBox(height: 5),
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
                          Text(
                            'Remember me',
                            style: TextStyle(color: Colors.orange),
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Email();
                                },
                              );
                            },
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
                            if (isEmail(usernameController.text) ||
                                isPhoneNumber(usernameController.text)) {

                              attemptLogin(context);
                            } else {
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
