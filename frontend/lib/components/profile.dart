import 'package:flutter/material.dart';
import 'package:frontend/components/login.dart';
import 'package:frontend/components/settings.dart';
import 'package:frontend/components/favorites.dart';
import 'package:frontend/components/Map.dart';
import 'package:frontend/main.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void signUserOut() {
    // sign out user

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LogoutPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('User Home'),
          // "logout" functionality - Working
          actions: [
            IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const MyMap()));
                },
                child: const Text('Interactive Map!')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Favorites()));
                },
                child: const Text('Favorites')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Settings()));
                },
                child: const Text('Settings'))
          ],
        ));
  }
}
