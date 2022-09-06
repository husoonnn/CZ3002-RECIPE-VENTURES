import 'dart:core';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_ventures/controllers/favouritesController.dart';
import 'package:recipe_ventures/data/appUser.dart';
import 'package:recipe_ventures/data/favRecipe.dart';
import 'package:recipe_ventures/pages/recipedetails.dart';
import 'package:recipe_ventures/utils/constants.dart';

import 'navBar.dart';

class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  // final List<FavRecipe> items = [
  //   // FavRecipe(title: 'Mapo Tofu', id: '1'),
  //   // FavRecipe(title: 'Grandma\'s Homemade Cookies', id: '2'),
  //   // FavRecipe(title: 'Pork Cutlet', id: '3'),
  // ];
  final bool _isInit = true;
  FavouritesController fc = FavouritesController();

  _deleteFavConfirmation(BuildContext context, String docID) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
                "Are you sure you want to delete this recipe from your favourites?",
                style: Theme.of(context).textTheme.bodyText2),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                      child: Text('cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  MaterialButton(
                      child: Text(
                        'yes',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        fc.deleteFavourite(docID);

                        // setState(() {
                        //   _visibilityTag = false;
                        // });
                        Navigator.pop(context);
                      }),
                ],
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Favourites', style: Theme.of(context).textTheme.headline6),
      ),
      body: StreamBuilder<List<FavRecipe>>(
          stream: FavRecipe.getFavRecipes(user.uid),
          builder:
              (BuildContext context, AsyncSnapshot<List<FavRecipe>> snapshot) {
            if (snapshot.hasData) {
              return Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: ListView.separated(
                    itemCount: snapshot.data.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      String title = snapshot.data[index].title;
                      FavRecipe fav = snapshot.data[index];
                      // bool isSaved = snapshot.data.contains(fav);

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: kOrange, width: 3)),
                        child: ListTile(
                            visualDensity:
                                VisualDensity(horizontal: 4, vertical: -4),
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(20.0)),
                            // tileColor: Colors.red,
                            // minVerticalPadding: 10,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RecipeDetails(
                                            recipeID: fav.recipeID,
                                            recipeName: title,
                                            addedTofav: true,
                                          )));
                            },
                            title: Text(
                              title,
                              style: TextStyle(fontSize: 20),
                            ),
                            trailing: IconButton(
                              padding: EdgeInsets.only(bottom: 3, left: 15),
                              icon: Icon(
                                Icons.favorite,
                                color: Colors.red[600],
                                size: 30,
                              ),
                              onPressed: () {
                                _deleteFavConfirmation(context, fav.docID);
                              },
                            )),
                      );
                    },
                  ));
            } else {
              return Container();
            }
          }),
      // bottomNavigationBar: Navbar(),
    );
  }
}
