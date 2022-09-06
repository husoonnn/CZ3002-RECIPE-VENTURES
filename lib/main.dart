import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:recipe_ventures/pages/favourites.dart';
import 'package:recipe_ventures/pages/homepage.dart';
import 'package:recipe_ventures/pages/ingredientConfirmationPage.dart';
import 'package:recipe_ventures/pages/navBar.dart';
import 'package:recipe_ventures/pages/recipedetails.dart';
import 'package:recipe_ventures/pages/recipeslist.dart';
import 'package:recipe_ventures/pages/store.dart';
import 'package:recipe_ventures/utils/constants.dart';
import 'package:recipe_ventures/theme/themeManager.dart';
import 'package:provider/provider.dart';
import 'package:recipe_ventures/pages/welcomepage.dart';
import 'package:recipe_ventures/pages/loginpage.dart';
import 'package:recipe_ventures/pages/signuppage.dart';
import 'package:recipe_ventures/wrapper.dart';
import 'utils/globals.dart' as globals;

import 'data/appUser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => new ThemeNotifier(), child: Phoenix(child: MyApp())));
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback resumeCallBack;

  LifecycleEventHandler({this.resumeCallBack});

  @override
  Future<Null> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.resumed:
        await resumeCallBack();
        break;
    }
  }
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {

    User currUser = FirebaseAuth.instance.currentUser;

    String uid = (currUser == null) ? null : currUser.uid;

    return MultiProvider(
        providers: [
          StreamProvider<AppUser>.value(value: AppUser.getUserFromID(uid))
        ],
        child: Consumer<ThemeNotifier>(
          builder: (context, theme, _) => MaterialApp(
            theme: theme.getTheme(),
            initialRoute: '/',
            routes: {
              '/': (context) => Wrapper(),
              '/Login': (context) => LoginPage(),
              '/Signup': (context) => SignupPage(),
              '/Favourites': (context) => Favourites(),
              '/Store': (context) => Store(),
            },
            // home: Scaffold(
            //   bottomNavigationBar: Navbar(),
            //   body: Navigator(
            //     onGenerateRoute: (settings) {
            //       Widget page = Homepage();
            //       if (settings.name == 'Store') page = Store();
            //       else if (settings.name == 'Favourites') page = Favourites();
            //       else if (settings.name == 'Homepage') page = Homepage();
            //       return MaterialPageRoute(builder: (_) => page);
            //     },
            //   ),
            // )
            // MainPage(),
          ),
        ));
  }
}

