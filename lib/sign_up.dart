import 'package:test_app/service/auth_service.dart';
import 'package:test_app/page-scan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_app/utils/customColors.dart';
import 'package:test_app/utils/customTextStyle.dart';
/* This page is where users sign up for the application.

Users enter their email, password, username, and last name data separately from text fields
and send it to the signUp function with the sign-up button.

In the signUp() function, the data is sent to both Firestore and Firebase Authentication
through the Future<String?> signUp() function in the auth.service,
and a separate uid is assigned to each user from the moment they register.

After registering, there is a button for the user to go to the login page. */
class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String email, password,username,lastname;
  final formkey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  AuthService authService= AuthService();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    String topImage = "assets/im/topImage.png";
    return Scaffold(
      body: appBody(height, topImage),
    );
  }

  SingleChildScrollView appBody(double height, String topImage) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topImageContainer(height, topImage),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleText(),
                    customSizedBox(),
                    userNameTextfield(),
                    customSizedBox(),
                    userLastNameTextfield(),
                    customSizedBox(),
                    emailTextField(),
                    customSizedBox(),
                    passwordTextField(),
                    customSizedBox(),
                    signUpButton(),
                    customSizedBox(),
                    backToLoginPage()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Text titleText() {
    return Text(
      "Please enter the information to create a new user.",
      style: CustomTextStyle.titleTextStyle,
    );
  }
  TextFormField userLastNameTextfield() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Fill in the Information Completely";
        } else {}
      },
      onSaved: (value) {
        lastname = value!;
      },
      style: TextStyle(color: Colors.white),
      decoration: customInputDecoration("Lastname"),
    );
  }
TextFormField userNameTextfield() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Fill in the Information Completely";
        } else {}
      },
      onSaved: (value) {
        username = value!;
      },
      style: TextStyle(color: Colors.white),
      decoration: customInputDecoration("Name"),
    );
  }
  TextFormField emailTextField() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Fill in the Information Completely";
        } else {}
      },
      onSaved: (value) {
        email = value!;
      },
      style: TextStyle(color: Colors.white),
      decoration: customInputDecoration("Email"),
    );
  }

  TextFormField passwordTextField() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Fill in the Information Completely";
        } else {}
      },
      onSaved: (value) {
        password = value!;
      },
      obscureText: true,
      style: TextStyle(color: Colors.white),
      decoration: customInputDecoration("Password"),
    );
  }

  Center signUpButton() {
    return Center(
      child: TextButton(
        onPressed: signUp,
        child: customText(
          "Create New Account",
          Color.fromARGB(255, 196, 69, 111),
        ),
      ),
    );
  }

void signUp() async{
   if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      final result =
          await authService.signUp(email,username,lastname,password);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => ThirdPage()),
          (route) => false);
    } else {}
}


  Center backToLoginPage() {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, "/loginPage"),
        child: customText(
          "Back to Login Page",
          CustomColors.textButtonColor,
        ),
      ),
    );
  }

  Container topImageContainer(double height, String topImage) {
    return Container(
      height: height * .25,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(topImage),
        ),
      ),
    );
  }

  Widget customSizedBox() => SizedBox(
        height: 20,
      );

  Widget customText(String text, Color color) => Text(
        text,
        style: TextStyle(color: color),
      );

  InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
    );
  }
}