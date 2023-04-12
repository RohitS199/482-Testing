import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/components/profile.dart';
// import 'package:frontend/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:frontend/components/special_button.dart';
import 'package:frontend/components/sign_up.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isChecked = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    _loadUserEmailPassword();
    super.initState();
  }

  void signUserIn() async {
    final String email = emailController.text;
    final String password = passwordController.text;

    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      bool isValid = jsonDecode(response.body)['isValid'];
      if (isValid) {
        // logging in
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Profile()));
      } else {
        showErrorMessage("Incorrect email or password");
      }
    } else {
      showErrorMessage("Failed to login");
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
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 20, 30, 20),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
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
                                            "Log In",
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
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 0, 0, 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                            TextFormField(
                                              controller: emailController,
                                              cursorColor: HexColor("#4f4f4f"),
                                              decoration: InputDecoration(
                                                hintText: "example@example.com",
                                                fillColor: HexColor("#f0f3f1"),
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 20, 20, 20),
                                                hintStyle:
                                                    GoogleFonts.montserrat(
                                                  fontSize: 15,
                                                  color: HexColor("#8d8d8d"),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  borderSide: BorderSide.none,
                                                ),
                                                filled: true,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 1,
                                            ),
                                            // Text(
                                            //   "Username",
                                            //   style: GoogleFonts.montserrat(
                                            //     fontSize: 16,
                                            //     color: HexColor("#8d8d8d"),
                                            //   ),
                                            // ),
                                            // const SizedBox(
                                            //   height: 5,
                                            // ),
                                            // TextField(
                                            //   cursorColor: HexColor("#4f4f4f"),
                                            //   decoration: InputDecoration(
                                            //     hintText: "username",
                                            //     fillColor: HexColor("#f0f3f1"),
                                            //     contentPadding:
                                            //         const EdgeInsets.fromLTRB(
                                            //             20, 20, 20, 20),
                                            //     hintStyle:
                                            //         GoogleFonts.montserrat(
                                            //       fontSize: 15,
                                            //       color: HexColor("#8d8d8d"),
                                            //     ),
                                            //     border: OutlineInputBorder(
                                            //       borderRadius:
                                            //           BorderRadius.circular(30),
                                            //       borderSide: BorderSide.none,
                                            //     ),
                                            //     filled: true,
                                            //   ),
                                            // ),
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
                                              obscureText: true,
                                              controller: passwordController,
                                              cursorColor: HexColor("#4f4f4f"),
                                              decoration: InputDecoration(
                                                hintText: "*************",
                                                fillColor: HexColor("#f0f3f1"),
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 20, 20, 20),
                                                hintStyle:
                                                    GoogleFonts.montserrat(
                                                  fontSize: 15,
                                                  color: HexColor("#8d8d8d"),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  borderSide: BorderSide.none,
                                                ),
                                                filled: true,
                                                focusColor: HexColor("#44564a"),
                                              ),
                                            ),
                                            SizedBox(
                                                height: 24.0,
                                                width: 24.0,
                                                child: Theme(
                                                  data: ThemeData(
                                                      unselectedWidgetColor:
                                                          const Color(
                                                              0xff00C8E8) // Your color
                                                      ),
                                                  child: Checkbox(
                                                      activeColor: const Color(
                                                          0xff00C8E8),
                                                      value: _isChecked,
                                                      onChanged:
                                                          _handleRememberMe),
                                                )),
                                            const SizedBox(width: 10.0),
                                            const Text("Remember Me",
                                                style: TextStyle(
                                                    color: Color(0xff646464),
                                                    fontSize: 12,
                                                    fontFamily: 'montserrat')),
                                            // submission, check if user is already registered, if not register them
                                            MyButton(
                                              onPressed: signUserIn,
                                              buttonText: 'Proceed',
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      35, 0, 0, 0),
                                              child: Row(
                                                children: [
                                                  Text("Don't have an account?",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize: 15,
                                                        color:
                                                            HexColor("#8d8d8d"),
                                                      )),
                                                  TextButton(
                                                    child: Text(
                                                      "Sign Up",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize: 15,
                                                        color:
                                                            HexColor("#44564a"),
                                                      ),
                                                    ),
                                                    onPressed: () =>
                                                        Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const SignUpScreen(),
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
                                  )))
                        ],
                      )
                    ],
                  )
                ])));
  }

  _handleRememberMe(bool? value) {
    print("Handle Remember Me");
    _isChecked = value!;
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setBool("remember_me", value);
        prefs.setString('email', emailController.text);
        prefs.setString('password', passwordController.text);
      },
    );
    setState(() {
      _isChecked = value;
    });
  }

  void _loadUserEmailPassword() async {
    print("Load Email");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var email = prefs.getString("email") ?? "";
      var password = prefs.getString("password") ?? "";
      var rememberMe = prefs.getBool("remember_me") ?? false;

      print(rememberMe);
      print(email);
      print(password);
      if (rememberMe) {
        setState(() {
          _isChecked = true;
        });
        emailController.text = email;
        passwordController.text = password;
      }
    } catch (e) {
      print(e);
    }
  }
}

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Logout"),
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (route) => false);
              },
              child: const Icon(Icons.logout))
        ],
      ),
    );
  }
}
