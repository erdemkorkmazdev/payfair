import 'dart:math';
import 'package:test_app/login_page.dart';
import 'package:test_app/sign_up.dart';
import 'package:flutter/material.dart';
/* This is the first page encountered when the application is opened.

There are two buttons, Login and Register,
through which users can log in or register for the application on line 83 and line 105. */
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.deepPurpleAccent,
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationZ(pi / 4),
                    child: Container(
                      width: 270,
                      height: 270,
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child:const Center(
                        child: Text(
                          "PayFair",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationZ(pi / 4),
                    child: Container(
                      width: 120,
                      height: 120,
                      child: Center(
                        child: Text(
                          'OCR',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(226, 165, 165, 1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
            Positioned(
              bottom: 24,
              right: 24,
              child: Material(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 61, 63, 65),
                    minimumSize: Size(167, 54),
                  ),
                  child: const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              left: 24,
              child: Material(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 61, 63, 65),
                    minimumSize: Size(167, 54),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}