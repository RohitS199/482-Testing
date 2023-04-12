import 'package:flutter/material.dart';
import 'dart:io';

import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

// import components
import 'package:frontend/components/login.dart';
import 'package:frontend/components/sign_up.dart';
import 'package:frontend/components/special_button.dart';
import 'components/Map.dart';

Future<String?> getLocalIpAddress() async {
  try {
    List<NetworkInterface> interfaces = await NetworkInterface.list();
    for (NetworkInterface interface in interfaces) {
      if (!interface.name.startsWith('lo')) {
        for (InternetAddress address in interface.addresses) {
          if (address.type == InternetAddressType.IPv4) {
            return address.address;
          }
        }
      }
    }
  } catch (e) {
    print('Error getting IP address: $e');
  }
  return null;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String ACCESS_TOKEN = "sk.eyJ1IjoiZnJhbmttLTciLCJhIjoiY2xmbXVxandwMDB5ODN0cGozMWxtbTJuYSJ9.CQyb_Lv7LG4mSdZDN_IQmw";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CrowdWatch',
      theme: ThemeData(
          fontFamily: 'Montserrat',
          scaffoldBackgroundColor: HexColor("#4577CA"),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor("#4577CA"),
                  foregroundColor: HexColor("#DCDCDC"))),
          colorScheme: ColorScheme(
              brightness: Brightness.light,
              primary: HexColor("#4577CA"),
              onPrimary: HexColor("#DCDCDC"),
              secondary: HexColor("#D4D4D4"),
              onSecondary: HexColor("#000000"),
              error: HexColor("#FF8F40"),
              onError: HexColor("#000000"),
              background: HexColor("#4577CA"),
              onBackground: HexColor("#DCDCDC"),
              surface: HexColor("#D4D4D4"),
              onSurface: HexColor("#000000"))
          // colorScheme: ColorScheme.fromSeed(seedColor: HexColor("#4577CA")),
          ),
      home: const HomeScreen(),
      // home: const AuthPage(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.only(top: 50, bottom: 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0)),
            color: HexColor('#FFDFC9')
                .withOpacity(0), // change to 1 for color, 0 for dark blue
            child: Image.asset(
              "lib/images/Logo_Mockup.png",
              height: 200,
              width: 200,
              alignment: Alignment.center,
            ),
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 30),
            elevation: 0,
            color: Colors.transparent,
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.montserrat(
                  fontSize: 55.0,
                  height: 1.5,
                  color: HexColor("#FF8F40"),
                ),
                children: <TextSpan>[
                  const TextSpan(text: 'crowd'),
                  TextSpan(
                      text: 'watch',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          color: HexColor("#FFDFC9"))),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: Text("Where's the crowd at?",
                style: GoogleFonts.montserrat(
                  decoration: TextDecoration.none,
                  color: Colors.white,
                  // fontFamily: 'Montserrat',
                  fontSize: 30,
                )),
          ),
          Column(
            children: <Widget>[
              MyButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                buttonText: "Log In",
              ),
              MyButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()));
                },
                buttonText: "Sign Up",
              ),
              MyButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const MyMap()));
                },
                buttonText: "Continue as Guest",
              ),
            ],
          )
        ],
      ),
    ));
  }
}
