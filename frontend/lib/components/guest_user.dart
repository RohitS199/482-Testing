// everything for the guest user should be here

import 'package:flutter/material.dart';
import 'package:frontend/components/settings.dart';
import 'package:frontend/components/Map.dart';

class DefaultProfile extends StatefulWidget {
  const DefaultProfile({super.key});

  @override
  State<DefaultProfile> createState() => _DefaultProfileState();
}

class _DefaultProfileState extends State<DefaultProfile> {
  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(
      content: const Text('Please sign in to access this feature.'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Guest Home'),
          // "logout" functionality - TODO
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
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const Favorites()));
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
