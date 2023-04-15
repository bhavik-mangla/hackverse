import 'package:flutter/material.dart';
import '../auth.dart';
import 'sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? const SignIn()
        : Scaffold(
            appBar: AppBar(
              title: const Text(
                "Reset Password",
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
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 50.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 20.0),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Email',
                            ),
                            validator: (val) =>
                                val!.isEmpty ? 'Enter an email' : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue[900],
                            ),
                            child: const Text(
                              'Reset Password',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                //toast

                                dynamic result =
                                    await _auth.resetPassword(email);
                                if (result['error'] != null) {
                                  setState(() {
                                    //toast
                                    Fluttertoast.showToast(
                                        msg: "Invalid email " + result['error'],
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Reset password email sent",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  setState(() => loading = true);
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
