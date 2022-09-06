import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:recipe_ventures/controllers/authenticationController.dart';
import 'package:recipe_ventures/controllers/userController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_ventures/utils/globals.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:recipe_ventures/pages/loginpage.dart';

import 'navBar.dart';

class SignupPage extends StatelessWidget {
  @override
  final myEmailController = TextEditingController();
  final myPasswordController = TextEditingController();
  final myUsernameController = TextEditingController();
  final myConfirmpasswordController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
            print('Back to welcome page');
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 80,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("Sign up", style: Theme.of(context).textTheme.headline3),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Create an account, It's free ",
                      style: Theme.of(context).textTheme.subtitle1)
                ],
              ),
              Column(
                children: <Widget>[
                  Text('Username',
                      style: Theme.of(context).textTheme.subtitle1),
                  SizedBox(height: 5),
                  TextField(
                      controller: myUsernameController,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[400]),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[400]))),
                      obscureText: false),
                  Text('Email Address',
                      style: Theme.of(context).textTheme.subtitle1),
                  SizedBox(height: 5),
                  TextField(
                      controller: myEmailController,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[400]),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[400]))),
                      obscureText: false),
                  Text('Password',
                      style: Theme.of(context).textTheme.subtitle1),
                  SizedBox(height: 5),
                  TextField(
                      controller: myPasswordController,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[400]),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[400]))),
                      obscureText: true),
                  Text('Confirm Password',
                      style: Theme.of(context).textTheme.subtitle1),
                  SizedBox(height: 5),
                  TextField(
                      controller: myConfirmpasswordController,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[400]),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[400]))),
                      obscureText: true),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 3, left: 3),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () async {
                    print("Sign up pressed");
                    bool samePassword = await AuthenticationController()
                        .checkSamePassword(myPasswordController.text.trim(),
                            myConfirmpasswordController.text.trim());
                    if (samePassword == true) {
                      final signupCode = await AuthenticationController()
                          .registerWithEmailAndPassword(
                              myUsernameController.text.trim(),
                              myEmailController.text.trim(),
                              myPasswordController.text.trim());
                      if (signupCode == 'Pass') {
                        // globals.currUserId =
                        //     FirebaseAuth.instance.currentUser.uid;
                        Phoenix.rebirth(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Navbar()));
                      } else if (signupCode == 'WeakPassword') {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text(
                                      "Password is too weak. Minimum 6 characters required."),
                                  titleTextStyle:
                                      Theme.of(context).textTheme.subtitle1);
                            });
                      } else if (signupCode == 'ExistingAccount') {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text(
                                      "Account with email already exists. Please log in."),
                                  titleTextStyle:
                                      Theme.of(context).textTheme.subtitle1);
                            });
                      } else if (signupCode == 'InvalidEmail') {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text(
                                      "The email address is badly formatted. Please try again with proper email address."),
                                  titleTextStyle:
                                      Theme.of(context).textTheme.subtitle1);
                            });
                      } else if (signupCode == 'GenericError') {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text(
                                      "Failed to sign up. Please try again with proper input."),
                                  titleTextStyle:
                                      Theme.of(context).textTheme.subtitle1);
                            });
                      }
                    } else if (samePassword == false) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: Text(
                                    "Password confirmation does not match."),
                                titleTextStyle:
                                    Theme.of(context).textTheme.subtitle1);
                          });
                    }
                  },
                  color: Color(0xff0095FF),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.black, width: 1),
                  ),
                  child: Text("Sign up",
                      style: Theme.of(context).textTheme.button),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Already have an account?"),
                  TextButton(
                      child: Text("Log in",
                          style: Theme.of(context).textTheme.button),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/Login', (_) => false);
                        print('Signup -> Login Pressed');
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// we will be creating a widget for text field
Widget inputFile({label, obscureText = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
      ),
      SizedBox(
        height: 5,
      ),
      TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400]))),
      ),
      SizedBox(
        height: 10,
      )
    ],
  );
}
