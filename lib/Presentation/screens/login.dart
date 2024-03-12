import 'package:flutter/material.dart';
import 'package:tec_admin/Constants/Colours.dart';
import 'package:tec_admin/Data/Models/Loginmodel.dart';
import 'package:tec_admin/Data/Repositories/Login_repo.dart';
import 'package:tec_admin/Presentation/widgets/EmailforOtp.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserRepository loginRepository = UserRepository();
  bool isPasswordVisible = false;
  bool rememberMe = false;

  bool isEmail(String input) {
    final emailRegex =
    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(input);
  }

  bool isPhoneNumber(String input) {
    final phoneNumberRegex = RegExp(r'^\d{10}$');
    return phoneNumberRegex.hasMatch(input);
  }

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
      backgroundColor: Colours.orange,
      body: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 1.4,
            child: Image.asset(
              "assets/background.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Image.asset(
              "assets/map.png",
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colours.white.withOpacity(0.9), // Adjust the opacity of the white background

              ),
              width: MediaQuery.of(context).size.width * 0.28,
              height: MediaQuery.of(context).size.height * 0.55,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/logo.png",
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.1,
                        ),
                      ),
                      SizedBox(height: 40,),
                      TextField(
                        controller: usernameController,
                        onEditingComplete: _login,
                        decoration: InputDecoration(
                          hintText: "Username",
                          fillColor: Colors.grey.shade300,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      TextField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        onEditingComplete: _login,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade300,
                          hintText: "Password",
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
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
                      SizedBox(height: 5,),
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
                            style: TextStyle(color: Colors.black),
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
                              style: TextStyle(color: Colours.orange),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Stack(
                        children: [

                          Center(
                            child: TextButton(
                              onPressed: _login,
                              child: Text(
                                "Login",
                                style: TextStyle(color: Colours.black, fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
