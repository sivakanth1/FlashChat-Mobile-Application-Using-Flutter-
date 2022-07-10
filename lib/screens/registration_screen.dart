import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/error_snackbar.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  late bool showSpinner = false;
  late String email;
  late String password;
  late String displayname;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: "Enter your email",
                  icon: const Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
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
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: "Enter your password",
                  icon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                color: Colors.blueAccent,
                text: 'Register',
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    FirebaseAuth.instance
                        .authStateChanges()
                        .listen((User? user) async {
                      if (user != null) {
                        await user.updateDisplayName(displayname);
                      }
                    });
                    await FirebaseAuth.instance.currentUser
                        ?.sendEmailVerification();
                    final loggedUser = FirebaseAuth.instance.currentUser;
                    if (loggedUser?.emailVerified ?? true && newUser != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                      email = "";
                      password = "";
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar("Please Verify Your Email"));
                      email = "";
                      password = "";
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      ScaffoldMessenger.of(context).showSnackBar(
                          snackBar("The password provided is too weak."));
                    } else if (e.code == 'email-already-in-use') {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar(
                          "The account already exists for that email."));
                    } // else if block
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackBar("error:$e"));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
