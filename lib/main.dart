import 'package:flutter/material.dart';
import 'package:test_app/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_app/page-scan.dart';
import 'package:test_app/sign_up.dart';
import 'firebase_options.dart';
import 'login_page.dart';
/*This code is the main file of the Flutter app.
It initializes the Firebase app and sets up the MaterialApp.
The home page is set to the HomePage widget,
and routes are defined for other pages such as LoginPage, SignUp, and ThirdPage. */
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  List<String> food = [];
  List<double> price = [];
  List<int> amount = [];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
        routes: {
          "/loginPage":(context)=> LoginPage(),
          "/signUp":(context) => SignUp(),
          "/thirdPage":(context) => ThirdPage(),
        }
    );
  }
}
