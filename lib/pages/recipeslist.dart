import 'package:flutter/material.dart';
import 'package:recipe_ventures/components/recipeComponent.dart';
import 'package:recipe_ventures/controllers/recipeController.dart';
import 'package:recipe_ventures/pages/recipedetails.dart';
import 'package:recipe_ventures/utils/globals.dart' as globals;

import '../main.dart';

class RecipeList extends StatefulWidget {
  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  RecipeController rc = RecipeController();
  var result;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildRecipesList(List<String> ingredientList) {
    return FutureBuilder(
        future: rc.generateRecipes(ingredientList),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return RecipeComponent(
                      recipeID: snapshot.data[index]['id'],
                      recipeName: snapshot.data[index]['title'],
                      addedToFav: snapshot.data[index]["isFavourite"],
                    );
                  }),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    rc.generateRecipes(globals.selectedIngredients);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Recipes Recommendation',
            style: Theme.of(context).textTheme.headline6),
      ),
      body: // can use a list view builder to iterate and display
          Column(
        children: [
          Expanded(
            child: _buildRecipesList(globals.selectedIngredients),
          ),
        ],
      ),
    );
  }
}
