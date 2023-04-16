import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'app/auth/authentication/auth.dart';
import 'app/auth/providers/sign.dart';
import 'app/config/theme/app_colors.dart';
import 'app/shared/widgets/avatar_widget.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  late AnimationController _controller;
  late int _selectedIndex;
  late int _previousIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _previousIndex = 0;
    _controller = AnimationController(
      vsync: this,
      //milliseconds: 800
      duration: const Duration(milliseconds: 500),
    )..forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    _controller.forward(from: 0.0);
    setState(() {
      _selectedIndex = index;
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _previousIndex = index;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    final data = Provider.of<SignInOrRegister>(context, listen: false);
    final User? uid = FirebaseAuth.instance.currentUser;
    final User user = uid!;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.14,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 32, right: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const FaIcon(FontAwesomeIcons.barsStaggered),
                  Text(
                    'Zoobi Menu',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const AvatarWidget()
                ],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(height * 0.01),
                  decoration: const BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 0,
                        color: Colors.black26,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(height * 0.010),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 0,
                              color: Colors.black26,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Center(child: Text("Your Profile")),
                      ),
                      SizedBox(
                        height: height * 0.015,
                      ),
                      Container(
                        padding: EdgeInsets.all(height * 0.010),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 0,
                              color: Colors.black26,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(height * 0.01),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: width * 0.0005,
                                        color: Colors.black26,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    margin:
                                        EdgeInsets.only(top: height * 0.005),
                                    child: CircleAvatar(
                                      radius: width * 0.12,
                                      backgroundImage: AssetImage(
                                          'assets/images/profile_pic.png'),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    user.email!,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            TextButton(
                              child: Text(
                                'Sign Out',
                                style: TextStyle(fontSize: width * 0.03),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Sign Out"),
                                      content: const Text(
                                          "Are you sure you want to logout?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            authService.signOut();
                                            Fluttertoast.showToast(
                                                msg: "Logged Out",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.green,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                            Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              'signin',
                                              (route) => false,
                                            );
                                          },
                                          child: const Text("Sign Out"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
