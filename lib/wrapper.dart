import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_ventures/data/appUser.dart';
import 'package:recipe_ventures/pages/homepage.dart';
import 'package:recipe_ventures/pages/navBar.dart';
import 'package:recipe_ventures/pages/welcomepage.dart';
import 'package:recipe_ventures/utils/globals.dart' as globals;

import 'components/loading.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
    final appUser = Provider.of<AppUser>(context);
    // String uid = globals.currUserId;

    if (user == null) {
      return WelcomePage();
    } else if (appUser == null || appUser.uid != user.uid) {
      return Loading();
    } else {
      // return Homepage();
      // print("printing from wrapper");
      // print(appUser);
      // print(user);
      return Navbar();
    }

    return Container();
  }
}
