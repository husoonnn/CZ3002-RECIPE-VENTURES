import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recipe_ventures/components/ingredientComponent.dart';
import 'package:recipe_ventures/controllers/authenticationController.dart';
import 'package:recipe_ventures/controllers/storeController.dart';
import 'package:recipe_ventures/data/appUser.dart';
import 'package:recipe_ventures/data/ingredient.dart';
import 'package:recipe_ventures/pages/navBar.dart';
import 'package:recipe_ventures/pages/recipeslist.dart';
import 'package:recipe_ventures/utils/globals.dart' as globals;

import '../main.dart';

class Store extends StatefulWidget {
  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  TextEditingController _nameController;
  TextEditingController _quantityController;
  DateTime selectedDate;
  String _expiry = '-';
  String _chosenUnit = 'units';
  bool _checkboxVisible = false;
  String recipeGetter = 'Generate Recipes';
  bool _selectAll = false;
  String _ingredientName;
  String _quantity;
  StoreController sc = StoreController();
  List<String> ingredients = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _quantityController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(Duration(hours: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _expiry = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
  }

  _addIngredient(BuildContext context) {
    final user = Provider.of<AppUser>(context, listen: false);
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Please input ingredient name:",
                          style: Theme.of(context).textTheme.bodyText2),
                      TextField(
                        onChanged: (newName) {
                          setState(() {
                            _ingredientName = newName;
                          });
                        },
                        controller: _nameController,
                      ),
                      Divider(
                        height: 20,
                      ),
                      Text("Please input expiry date of item:",
                          style: Theme.of(context).textTheme.bodyText2),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Expires on $_expiry',
                                style: Theme.of(context).textTheme.caption),
                            IconButton(
                              icon: Icon(
                                Icons.calendar_today,
                                color: Theme.of(context).accentColor,
                              ),
                              onPressed: () => _selectDate(context),
                            ),
                          ]),
                      Text("Please input quantity of ingredient:",
                          style: Theme.of(context).textTheme.bodyText2),
                      TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (newQty) {
                          setState(() {
                            _quantity = newQty;
                          });
                        },
                        controller: _quantityController,
                      ),
                      Divider(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Please input unit of item:",
                                style: Theme.of(context).textTheme.bodyText2),
                            DropdownButton<String>(
                              value: _chosenUnit,
                              items: <String>[
                                'g',
                                'kg',
                                'ml',
                                'litre',
                                'units',
                              ].map<DropdownMenuItem<String>>((String qty) {
                                return DropdownMenuItem<String>(
                                  value: qty,
                                  child: Text(qty,
                                      style:
                                          Theme.of(context).textTheme.caption),
                                );
                              }).toList(),
                              onChanged: (String unit) {
                                setState(() {
                                  _chosenUnit = unit;
                                });
                              },
                            ),
                          ]),
                    ]),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                        child: Text('ok'),
                        onPressed: () {
                          var ingredientsToAdd = [
                            {
                              'name': _ingredientName,
                              'quantity': int.parse(_quantity),
                              'metric': _chosenUnit,
                              'expiryDate': selectedDate,
                            }
                          ];
                          sc.addIngredients(ingredientsToAdd,
                              user.uid); // create ingredient obj then add
                          _nameController.clear();
                          _quantityController.clear();
                          _expiry = '-';
                          _chosenUnit = 'units';
                          Navigator.pop(context);
                        }),
                  ],
                )
              ],
            );
          });
        });
  }

  Widget _buildIngredientList(
      List<dynamic> ingredientList, checkboxVisible, selectAll) {
    // print("inside build ingredient list");
    // print(ingredientList.length);
    return ListView.builder(
        shrinkWrap: true,
        itemCount: ingredientList.length,
        itemBuilder: (BuildContext context, int index) {
          Ingredient ingredientObj = ingredientList[index];
          if (!ingredients.contains(ingredientObj.name)) {
            ingredients.add(ingredientObj.name);
          }
          return IngredientComponent(
            ingredientID: ingredientObj.ingredientID,
            ingredientName: ingredientObj.name,
            chosenQuantity: ingredientObj.quantity.toString(),
            chosenUnit: ingredientObj.metric,
            expiryDate: ingredientObj.expiryDate,
            checkboxVisibility: checkboxVisible,
            selectAll: selectAll,
            cfmIndex: -1,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);

    return StreamBuilder<List<dynamic>>(
        stream: Ingredient.getStore(user.uid),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                  leading: Visibility(
                    child: IconButton(
                      icon: Icon(
                        Icons.select_all,
                        color: Theme.of(context).accentColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _selectAll = !_selectAll;
                        });
                      },
                    ),
                    visible: _checkboxVisible,
                  ),
                  centerTitle: true,
                  title: Text('Store',
                      style: Theme.of(context).textTheme.headline6),
                  actions: [
                    Visibility(
                      child: MaterialButton(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Cancel',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _checkboxVisible = false;
                            recipeGetter = 'Generate Recipes';
                          });
                        },
                      ),
                      visible: _checkboxVisible,
                    ),
                  ]),
              body: // can use a list view builder to iterate and display
                  Column(
                children: [
                  SizedBox(height: 10),
                  Expanded(
                    child: _buildIngredientList(
                        snapshot.data, _checkboxVisible, _selectAll),
                  ),
                  Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            if (recipeGetter != 'Generate Recipes') {
                              if (_selectAll) {
                                globals.selectedIngredients = ingredients;
                              }
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RecipeList()));
                            }
                            _checkboxVisible = true;
                            recipeGetter = 'Get Recipes';
                          });
                        },
                        child: Text(recipeGetter,
                            style: TextStyle(
                                fontSize: 20, color: Color(0xFFFEA54B))),
                      ),
                    ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _addIngredient(context);
                },
                child: const Icon(Icons.add),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              // bottomNavigationBar: Navbar(),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                  leading: Visibility(
                    child: IconButton(
                      icon: Icon(
                        Icons.select_all,
                        color: Theme.of(context).accentColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _selectAll = !_selectAll;
                        });
                      },
                    ),
                    visible: _checkboxVisible,
                  ),
                  centerTitle: true,
                  title: Text('Store',
                      style: Theme.of(context).textTheme.headline6),
                  actions: [
                    Visibility(
                      child: MaterialButton(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Cancel',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _checkboxVisible = false;
                            recipeGetter = 'Generate Recipes';
                          });
                        },
                      ),
                      visible: _checkboxVisible,
                    ),
                  ]),
              body: // can use a list view builder to iterate and display
                  Column(
                children: [Center(child: CircularProgressIndicator())],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _addIngredient(context);
                },
                child: const Icon(Icons.add),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              // bottomNavigationBar: Navbar(),
            );
          }
        });

  }
}
