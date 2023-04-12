import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:frontend/components/login.dart';
import 'package:frontend/components/special_button.dart';
import 'package:frontend/controller/sign_up_controller.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  SignUpController signUpController = Get.put(SignUpController());

  String _errorMessage = "";

  void signUp() async {
    final String email = emailController.text;
    final String password = passwordController.text;

    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else if (response.statusCode == 409) {
      showErrorMessage('User already exists!');
    } else {
      showErrorMessage('Failed to register user: ${response.statusCode}');
    }
  }

  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: HexColor("#fed8c3"),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
          shrinkWrap: true,
          reverse: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 700,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: HexColor("#ffffff"),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  width: 67,
                                ),
                                Text(
                                  "Sign Up",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: HexColor("#4f4f4f"),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  Text(
                                    "Email",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      color: HexColor("#8d8d8d"),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextField(
                                    controller: emailController,
                                    onChanged: (value) {
                                      signUpController.setEmail(value);
                                    },
                                    onSubmitted: (value) {
                                      signUpController.setEmail(value);
                                    },
                                    cursorColor: HexColor("#4f4f4f"),
                                    decoration: InputDecoration(
                                      hintText: "example@example.com",
                                      fillColor: HexColor("#f0f3f1"),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20, 20, 20, 20),
                                      hintStyle: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: HexColor("#8d8d8d"),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  Text(
                                    "Username",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      color: HexColor("#8d8d8d"),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextField(
                                    cursorColor: HexColor("#4f4f4f"),
                                    decoration: InputDecoration(
                                      hintText: "username",
                                      fillColor: HexColor("#f0f3f1"),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20, 20, 20, 20),
                                      hintStyle: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: HexColor("#8d8d8d"),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                    child: Text(
                                      _errorMessage,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Password",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      color: HexColor("#8d8d8d"),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextField(
                                    onChanged: (value) {
                                      signUpController.setPassword(value);
                                    },
                                    onSubmitted: (value) {
                                      signUpController.setPassword(value);
                                    },
                                    obscureText: true,
                                    controller: passwordController,
                                    cursorColor: HexColor("#4f4f4f"),
                                    decoration: InputDecoration(
                                      hintText: "*************",
                                      fillColor: HexColor("#f0f3f1"),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20, 20, 20, 20),
                                      hintStyle: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: HexColor("#8d8d8d"),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      focusColor: HexColor("#44564a"),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  // submission, check if user is already registered, if not register them
                                  MyButton(
                                    onPressed: signUp,
                                    buttonText: 'Proceed',
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(35, 0, 0, 0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Already have an account?",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 15,
                                            color: HexColor("#8d8d8d"),
                                          ),
                                        ),
                                        TextButton(
                                          child: Text(
                                            "Log In",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 15,
                                              color: HexColor("#44564a"),
                                            ),
                                          ),
                                          onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
