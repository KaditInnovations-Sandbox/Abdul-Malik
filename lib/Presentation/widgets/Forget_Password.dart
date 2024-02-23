import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tec_admin/Presentation/widgets/Newpassword.dart';

class ForgotPasswordDialog extends StatefulWidget {
  final String email;

  const ForgotPasswordDialog({super.key, required this.email});

  @override
  _ForgotPasswordDialogState createState() => _ForgotPasswordDialogState(email: email);
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  late Timer _timer;
  int _seconds = 300;
  final String email;
  TextEditingController otpController = TextEditingController();

  _ForgotPasswordDialogState({required this.email});

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
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

  Future<void> _sendOtpAndEmailToApi(String email, String otp) async {
    String apiUrl = "http://localhost:8081/travelease/VerifyOTP";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'email': email,
          'otp': otp,
        },
      );

      if (response.statusCode == 201) {
        // API call successful
        print("\nAPI call successful");
        Navigator.of(context).pop(); // Close the current dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return NewPassword(email: email);
          },
        );
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter the OTP'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.security, size: 50, color: Colors.orange),
          const SizedBox(height: 10),
          Text('Check Your Mail $email'),
          const SizedBox(height: 10),
          TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _seconds > 0
                    ? null
                    : () {
                  // Resend OTP logic
                  setState(() {
                    _seconds = 75;
                    _startTimer();
                  });
                },
                child: Text('Resend OTP ($_seconds)'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async {
                  String enteredOtp = otpController.text;
                  await _sendOtpAndEmailToApi(email, enteredOtp);

                },
                child: const Text('Verify OTP'),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
