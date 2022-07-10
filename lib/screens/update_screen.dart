import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class UpdateScreen extends StatelessWidget {
  UpdateScreen({Key? key}) : super(key: key);

  late String displayname;
  static String id = 'registration_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
            onChanged: (value) {
              displayname = value;
            },
            decoration: kTextFieldDecoration.copyWith(
              hintText: "Enter your username/display name",
              icon: const Icon(Icons.account_circle_outlined),
            ),
          ),
          RoundedButton(
              color: Colors.blueAccent,
              text: 'Update',
              onPressed: () async {
                try {
                  print(FirebaseAuth.instance.currentUser);
                  FirebaseAuth.instance
                      .authStateChanges()
                      .listen((User? user) async {
                    if (user != null) {
                      await user.updateDisplayName(displayname);
                      print(FirebaseAuth.instance.currentUser?.displayName);
                    }
                  });
                } catch (e) {
                  print(e);
                }
              })
        ],
      ),
    );
  }
}
