import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_ventures/controllers/authenticationController.dart';
import 'package:recipe_ventures/controllers/loginController.dart';
import 'package:provider/provider.dart';
import 'package:recipe_ventures/data/appUser.dart';
import 'package:recipe_ventures/pages/ingredientConfirmationPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_ventures/pages/settingspage.dart';
import 'package:tflite/tflite.dart';

import 'navBar.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  File image;
  String _imageCaptureChoice;
  List _output;

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {
        print("model loaded");
        print(value);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 36,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      _output = output;
    });
    print(_output);
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model.tflite', labels: 'assets/labels.txt');
  }

  Future pickImageGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image');
    }
    classifyImage(image);
  }

  Future pickImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image');
    }
    classifyImage(image);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    return Scaffold(
      appBar: AppBar(
          // leading: IconButton(
          //   onPressed: () async {
          //     await LoginController().signOut();
          //     Phoenix.rebirth(context);
          //     // Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
          //     // print ('Back to welcome page');
          //   },
          //   icon: Icon(
          //     Icons.logout,
          //     size: 20,
          //     color: Colors.black,
          //   ),
          // ),
          centerTitle: true,
          title: Text('Welcome', style: Theme.of(context).textTheme.headline6),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => settingsPage()));
              },
            )
          ]),
      body: SingleChildScrollView(
        child:
        Column(
          children: [
            // Container to tap for taking picture
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 350,
              height: 40,
              child: Text("Hi ${user.displayName}! 👋",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start),
            ),
            SizedBox(
              width: 350,
              height: 20,
              child: Text("Just bought new ingredients? upload below.",
                  style: TextStyle(fontSize: 16), textAlign: TextAlign.start),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 15.0),
              child: FocusedMenuHolder(
                menuOffset: 10,
                onPressed: () {},
                menuItems: [
                  FocusedMenuItem(
                    title: Text('Take a picture'),
                    onPressed: () =>
                    {pickImageCamera(), _imageCaptureChoice = 'image'},
                  ),
                  FocusedMenuItem(
                      title: Text('Upload from gallery'),
                      onPressed: () =>
                      {pickImageGallery(), _imageCaptureChoice = 'gallery'}),
                ],
                menuWidth: MediaQuery.of(context).size.width - 50,
                openWithTap: true,
                blurBackgroundColor: Theme.of(context).backgroundColor,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: 1 / 1.15,
                    child: image != null
                        ? Image.file(
                      image,
                      width: 100,
                      height: 400,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      width: 100,
                      height: 400,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                'https://solidstarts.com/wp-content/uploads/when-can-babies-eat-eggs.jpg'),
                            fit: BoxFit.cover),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(Icons.camera_alt_rounded,
                              size: 80, color: Colors.black),
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                            child: Container(
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _output != null
                ? Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Get list of ingredient
                      List ingredients = [];
                      for (var i in _output) {
                        ingredients.add(i['label']);
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                IngredientConfirmationPage(
                                    ingredients, image)),
                      );
                      print('add to store');
                    },
                    child: Text('Add to store'),
                    style: ElevatedButton.styleFrom(
                      //fixedSize: Size(170, 36),
                        primary: Theme.of(context).primaryColor),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_imageCaptureChoice == 'gallery') {
                        pickImageGallery();
                      } else {
                        pickImageCamera();
                      }
                      print('retake image');
                    },
                    child: Text('Retake Image'),
                    style: ElevatedButton.styleFrom(
                      //fixedSize: Size(170, 36),
                        primary: Theme.of(context).primaryColor),
                  )
                ],
              ),
            )
                : Container(),

            // Center(
            //   // child: Text('upload Image')
            //   child: GestureDetector(
            //       onTap: () {
            //         TestManager().getTest();
            //       },
            //       child: Text('upload Image',
            //           style: Theme.of(context).textTheme.bodyText2)),
            // ),
            // GestureDetector(
            //   onTap: () {
            //     // RecipeManager().generateRecipes(["cheddar", "onion"]);
            //     RecipeManager().getRecipe("1416203");
            //   },
            //   child: Text('Generate recipes'),
            // )
          ],
        ),
      ),
      // bottomNavigationBar: Navbar(),
    );
  }
}
