import 'package:flutter/material.dart';
import 'package:recipe_ventures/controllers/authenticationController.dart';
import 'package:recipe_ventures/pages/favourites.dart';
import 'package:recipe_ventures/pages/homepage.dart';
import 'package:recipe_ventures/pages/store.dart';
import 'package:recipe_ventures/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Navbar extends StatefulWidget {
  int selectedIndex;

  Navbar({this.selectedIndex = 1});

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  final double iconSize = 30;

  final List<Widget> _pages = [Favourites(), Homepage(), Store()];

  void onTappedBar(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }

  Future printUsername() async {
    // var currentUserID =
    // await AuthenticationController().getCurrUserFromFirestore();
    //var currentUserID = await AuthenticationController().getCurrUserFromFirebase();
    //print('Username is: ' + currentUserID.displayName + '' + currentUserID.email + '' + currentUserID.uid);
    // print('Username is ' + currentUserID);
  }

  @override
  Widget build(BuildContext context) {
    printUsername();

    return Scaffold(
      body: _pages[widget.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: widget.selectedIndex,
          selectedItemColor: kOrange,
          onTap: onTappedBar,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite,
                    size: iconSize, color: Theme.of(context).accentColor),
                label: 'Favourites'),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_a_photo,
                    size: iconSize, color: Theme.of(context).accentColor),
                label: 'Upload Ingredients'),
            BottomNavigationBarItem(
                icon: Icon(Icons.kitchen,
                    size: iconSize, color: Theme.of(context).accentColor),
                label: 'Store')
          ]),
    );
  }
}
