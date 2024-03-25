import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  String errorMessage = '';

  void _clearErrorMessage() {
    setState(() {
      errorMessage = '';
    });
  }

  bool _isValidEmail(String email) {
    final emailRegex =
    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _login() async {
    final String email = usernameController.text;
    final String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please fill in all fields',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return;
    }

    if (!_isValidEmail(email)) {
      Fluttertoast.showToast(
        msg: 'Please enter a valid email address',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return;
    }

    final UserModel user = UserModel(username: email, password: password);
    final bool success = await UserRepository().login(user);

    if (success) {
      final token = UserRepository.getTokenFromLocalStorage();
      print('Token retrieved from Local Storage: $token');
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Fluttertoast.showToast(
        msg: 'Login failed',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
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
          Positioned(
            left: MediaQuery.of(context).size.width * 0.3563,
            top: MediaQuery.of(context).size.height * 0.686,
            child: Transform.rotate(
              angle: 40 * (3.14159 / 180),
              child: ClipPath(
                clipper: TriangleClipper(),
                child: Container(
                  height: 40,
                  width: 40,
                  color: Colours.orange,
                ),
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.6155,
            top: MediaQuery.of(context).size.height * 0.686,
            child: Transform.rotate(
              angle: -40 * (3.14159 / 180),
              child: ClipPath(
                clipper: TriangleClipper(),
                child: Container(
                  height: 40,
                  width: 40,
                  color: Colours.orange,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colours.white.withOpacity(0.7),
              ),
              width: MediaQuery.of(context).size.width * 0.28,
              height: MediaQuery.of(context).size.height * 0.6,
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
                        onChanged: (_) => _clearErrorMessage(),
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
                        onChanged: (_) => _clearErrorMessage(),
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
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.35,
            top: MediaQuery.of(context).size.height * 0.65,
            child: Material(
              elevation: 4, // elevation for the login button
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                  color: Colours.orange,
                ),
                child: TextButton(
                  onPressed: _login,
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colours.white, fontWeight: FontWeight.bold),
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

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
