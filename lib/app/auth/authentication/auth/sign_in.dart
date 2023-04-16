import 'package:hackverse/app/auth/authentication/auth/verify.dart';
import 'package:hackverse/app/src/home/presentation/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../authentication/auth.dart';
import 'package:provider/provider.dart';
import '../../providers/sign.dart';
import 'package:email_validator/email_validator.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

//sign in if user's email is verified
class _SignInState extends State<SignIn> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  AuthService auth = AuthService();

  bool _isValid = false;
  bool _isPasswordValid = false;
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
                "Log In",
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: email,
                      //curved edges

                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'Email',
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isValid = EmailValidator.validate(email.text.trim());
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

                      //show/hide password
                      onChanged: (value) {
                        setState(() {
                          _isPasswordValid = password.text.length > 6;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 25,
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
                              .signInWithEmailAndPassword(
                                  email: email.text.trim(),
                                  password: password.text);
                          if (userCredential.user!.emailVerified) {
                            data.setIsSignIn(true);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()));
                          } else {
                            Fluttertoast.showToast(
                                msg: "Please verify your email first",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const IsEmailVerified()));
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            Fluttertoast.showToast(
                                msg: "No user found for that email.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else if (e.code == 'wrong-password') {
                            Fluttertoast.showToast(
                                msg: "Wrong password provided for that user.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            Fluttertoast.showToast(
                                msg: "Something went wrong",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please enter valid email and password",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    child: const Text(
                      "Log In",
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  //dont have an account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'signup');
                        },
                        child: const Text("Register"),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'home');
                    },
                    child: const Text("Forgot Password"),
                  ),
                ],
              ),
            )));
  }
}
