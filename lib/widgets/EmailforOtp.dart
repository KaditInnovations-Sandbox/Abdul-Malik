import 'dart:async';
import 'package:flutter/material.dart';
import 'package:testapp/widgets/Forget_Password.dart';
import 'package:http/http.dart' as http;

class Email extends StatefulWidget {
  @override
  _EmailState createState() => _EmailState();
}

class _EmailState extends State<Email> {
  late Timer _timer;
  int _seconds = 75;
  TextEditingController emailController = TextEditingController();
  final _emailFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_seconds == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _seconds--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _sendOTP() async {
    if (_emailFormKey.currentState!.validate()) {
      String enteredEmail = emailController.text;

      bool emailSent = await _sendEmail(enteredEmail);

      if (emailSent) {
        bool apiResponse = await _makeApiCall(enteredEmail);

        if (apiResponse) {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ForgotPasswordDialog(email: enteredEmail);
            },
          );
        } else {
          print("API call failed");
          // Handle API call failure
          // You might want to show an error message to the user
        }
      } else {
        print("Email sending failed");
        // Handle email sending failure
        // You might want to show an error message to the user
      }
    }
  }

  Future<bool> _sendEmail(String email) async {
    // Replace the following with actual code to send an email
    // You may use a library like 'mailer' for sending emails
    // Example: https://pub.dev/packages/mailer
    // Return true if email is sent successfully, false otherwise
    // For now, we'll simulate success
    await Future.delayed(Duration(seconds: 2));
    return true;
  }

  Future<bool> _makeApiCall(String email) async {
    String apiUrl = "http://localhost:8081/travelease/ForgotPassword"; // Replace with your API endpoint

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: email,
      );

      if (response.statusCode == 200) {
        print("API call successful");
        return true;
      } else {

        print("API call failed with status code: ${response.statusCode}");
        print("Response data: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error during API call: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter Your Email'),
      content: Form(
        key: _emailFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.mail, size: 50, color: Colors.orange),
            SizedBox(height: 10),
            Text('Enter Your Email'),
            SizedBox(height: 10),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              onEditingComplete: () {
                _sendOTP();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email address';
                }
                if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                    .hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _sendOTP,
                  child: Text('Send OTP'),
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
}
