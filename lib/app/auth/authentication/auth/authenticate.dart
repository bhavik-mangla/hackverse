import 'package:hackverse/app/src/home/presentation/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'sign_in.dart';

import 'package:provider/provider.dart';

import '../../providers/sign.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<SignInOrRegister>(context);
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        data.setIsSignIn(false);
      } else {
        if (user.emailVerified) {
          data.setIsSignIn(true);
        } else {
          data.setIsSignIn(false);
        }
      }
    });
    if (data.isSignIn) {
      return const HomePage();
    } else {
      return const SignIn();
    }
  }
}
