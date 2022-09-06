import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recipe_ventures/controllers/authenticationController.dart';
import 'package:recipe_ventures/pages/homepage.dart';
import 'package:recipe_ventures/pages/signuppage.dart';
import 'package:recipe_ventures/controllers/loginController.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_ventures/pages/navBar.dart';
import 'package:recipe_ventures/widget/signinwidget.dart';
import 'package:recipe_ventures/components/loading.dart';
import 'package:recipe_ventures/utils/globals.dart' as globals;

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: ChangeNotifierProvider(
          create: (context) => LoginController(),
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final provider = Provider.of<LoginController>(context);

              if (provider.isSigningIn) {
                return Loading();
              } else if (snapshot.hasData) {
                return Navbar();
              } else {
                // print ('Snapshot has no data');
                return SignInWidget();
              }
            },
          ),
        ),
      );
}

// we will be creating a widget for text field
/*Widget inputFile({label, obscureText = false}) {
  final myController = TextEditingController();

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
        controller: myController,
        obscureText: obscureText,
        decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[400]),),
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[400]))),
      ),
      SizedBox(
        height: 10,
      )
    ],
  );
}*/
