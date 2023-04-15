import 'dart:async';

import 'package:hackverse/app/auth/authentication/auth/verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../providers/sign.dart';
import 'package:email_validator/email_validator.dart';

import '../auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController pswd = new TextEditingController();
  AuthService auth = AuthService();

  bool _isValid = false;
  bool _isPasswordValid = false;
  //check email verified then signup user
  bool _passwordVisible = false;
  @override
  void initState() {
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<SignInOrRegister>(context, listen: false);

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue[900],
          actions: [
            IconButton(
              onPressed: () {
                //help toast
                Fluttertoast.showToast(
                    msg: "Contact us to report bugs",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
                Navigator.pushNamed(context, 'dev');
              },
              icon: Icon(Icons.help),
            ),
          ],
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/images/img1.png',
                width: 250,
                height: 250,
              ),
              SizedBox(
                height: 25,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Sign Up to continue",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: email,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Email',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _isValid = EmailValidator.validate(value.trim());
                      // if (value.endsWith("@learner.manipal.edu")) {
                      //   _isValid = true;
                      // } else {
                      //   _isValid = false;
                      // }
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: password,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Password',
                    hintText: 'Enter secure password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.blue[900],
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _isPasswordValid = password.text.length > 6;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[900],
                  onPrimary: Colors.white,
                ),
                onPressed: () async {
                  if (_isValid && _isPasswordValid) {
                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                              email: email.text.trim(),
                              password: password.text);
                      if (userCredential.user != null) {
                        Fluttertoast.showToast(
                            msg: "Verification link sent to your email");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IsEmailVerified()));
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        Fluttertoast.showToast(
                            msg: 'The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        Fluttertoast.showToast(
                            msg: 'The account already exists for that email.');
                      }
                    } catch (e) {
                      print(e);
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Invalid Email or Password");
                  }
                },
                child: Text("Sign Up"),
              ),
              SizedBox(
                height: 25,
              ),
              //dont have an account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Log In"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
