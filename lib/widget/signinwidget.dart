import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recipe_ventures/controllers/authenticationController.dart';
import 'package:recipe_ventures/pages/signuppage.dart';
import 'package:recipe_ventures/controllers/loginController.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_ventures/pages/navBar.dart';
import 'package:recipe_ventures/controllers/userController.dart';

class SignInWidget extends StatelessWidget {
  @override
  final myEmailController = TextEditingController();
  final myPasswordController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        height: MediaQuery.of(context).size.height - 80,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Login", style: Theme.of(context).textTheme.headline4),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Login to your account",
                        style: Theme.of(context).textTheme.subtitle1)
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: <Widget>[
                      Text('Email Address',
                          style: Theme.of(context).textTheme.subtitle1),
                      SizedBox(height: 5),
                      TextField(
                          controller: myEmailController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[400]),
                              ),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[400]))),
                          obscureText: false),
                      Text('Password',
                          style: Theme.of(context).textTheme.subtitle1),
                      SizedBox(height: 5),
                      TextField(
                          controller: myPasswordController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[400]),
                              ),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[400]))),
                          obscureText: true),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    padding: EdgeInsets.only(top: 0, left: 3),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () async {
                        print("Login pressed");
                        final loginBoolean = await AuthenticationController()
                            .signInWithEmailAndPassword(
                                myEmailController.text.trim(),
                                myPasswordController.text.trim());
                        if (loginBoolean == 'Pass') {
                          Phoenix.rebirth(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Navbar()));
                        } else if (loginBoolean == 'WrongPassword') {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: Text(
                                        "Password is incorrect. Please try again."),
                                    titleTextStyle:
                                        Theme.of(context).textTheme.subtitle1);
                              });
                        } else if (loginBoolean == 'InvalidEmail') {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: Text(
                                        "The email address is badly formatted. Please try again"),
                                    titleTextStyle:
                                        Theme.of(context).textTheme.subtitle1);
                              });
                        } else if (loginBoolean == 'Usernotfound') {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: Text(
                                        "Account does not exist. Please try again"),
                                    titleTextStyle:
                                        Theme.of(context).textTheme.subtitle1);
                              });
                        } else if (loginBoolean == 'ExceedAttempts') {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: Text(
                                        "The maximum number of attempts has been exceeded. Please try again later."),
                                    titleTextStyle:
                                        Theme.of(context).textTheme.subtitle1);
                              });
                        } else if (loginBoolean == 'GenericError') {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: Text(
                                        "The email/password entered is invalid. Please try again."),
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
                      child: Text("Login",
                          style: Theme.of(context).textTheme.button),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final provider =
                          Provider.of<LoginController>(context, listen: false);
                      await provider.login();
                      final user = FirebaseAuth.instance.currentUser;

                      UserController()
                          .createUser(user.displayName, user.email, user.uid);

                      try {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Navbar()));
                      } catch (e) {
                        return null;
                      }
                    },
                    label: Text('Sign in with google',
                        style: Theme.of(context).textTheme.button),
                    icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
                    style: OutlinedButton.styleFrom(
                      primary: Colors.white,
                      minimumSize: Size(double.infinity, 60),
                      padding: EdgeInsets.only(top: 3, left: 3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      side: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Don't have an account?"),
                    TextButton(
                        child: Text("Sign Up",
                            style: Theme.of(context).textTheme.button),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/Signup', (_) => false);
                          print('Login -> Signup Pressed');
                        }),
                  ],
                ),
              ],
            ))
          ],
        ),
      )),
    );
  }
}
/*

class SignInWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      CustomPaint(painter: BackgroundPainter()),
      buildSignUp(),
    ],
  );

  Widget buildSignUp() => Column(
    children: [
      Spacer(),
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          width: 175,
          child: Text(
            'Welcome Back To HDB App',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      Spacer(),
      GoogleSignupButtonWidget(),
      SizedBox(height: 12),
      Text(
        'Login to continue',
        style: TextStyle(fontSize: 16),
      ),
      Spacer(),
    ],
  );
}
*/
