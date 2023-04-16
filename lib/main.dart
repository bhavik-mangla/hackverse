import 'package:hackverse/app/auth/authentication/auth/forgetPassword.dart';
import 'package:hackverse/app/src/category/category_list_page.dart';
import 'package:hackverse/app/src/home/presentation/home_page.dart';
import 'package:hackverse/app/src/home/presentation/shop_page.dart';
import 'package:hackverse/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/auth/authentication/auth.dart';
import 'app/auth/authentication/auth/authenticate.dart';
import 'app/auth/authentication/auth/sign_in.dart';
import 'app/auth/authentication/auth/sign_up.dart';
import 'app/auth/providers/sign.dart';
import 'app/src/home/presentation/home_page2.dart';
import 'app/src/product_detail/presentation/product_detail_page.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          value: AuthService().userChanges,
          initialData: null,
          updateShouldNotify: (_, __) => true,
        ),
        ChangeNotifierProvider<SignInOrRegister>(
          create: (_) => SignInOrRegister(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        title: 'Snoopy',
        initialRoute: '/',
        routes: {
          '/': (context) => const Authenticate(),
          'signup': (context) => const SignUp(),
          'signin': (context) => const SignIn(),
          'home': (context) => HomePage(),
          'forgot': (context) => ResetPassword(),
          '/profile': (context) => const Profile(),
          'category': (context) => CategoryListPage(),
          'shop': (context) => ShopPage(),
          'home2': (context) => HomePage2(),
        },
      ),
    );
  }
}
