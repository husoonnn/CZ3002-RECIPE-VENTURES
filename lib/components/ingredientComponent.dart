import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recipe_ventures/controllers/storeController.dart';
import 'package:recipe_ventures/data/ingredient.dart';
import 'package:recipe_ventures/utils/globals.dart' as globals;

import '../main.dart';

class IngredientComponent extends StatefulWidget {
  String ingredientID;
  String ingredientName;
  String chosenQuantity;
  String chosenUnit;
  DateTime expiryDate;
  bool checkboxVisibility;
  bool selectAll;
  int cfmIndex;

  IngredientComponent({
    @required this.ingredientID,
    @required this.ingredientName,
    @required this.chosenQuantity,
    @required this.chosenUnit,
    @required this.expiryDate,
    @required this.checkboxVisibility,
    @required this.selectAll,
    @required this.cfmIndex,
  });

  @override
  _IngredientComponentState createState() => _IngredientComponentState();
}

class _IngredientComponentState extends State<IngredientComponent> {
  TextEditingController _nameController;
  TextEditingController _quantityController;
  bool _visibilityTag = true;
  DateTime selectedDate = DateTime.now();
  String _expiry = 'Expiring on: ';
  DateTime _alertExpiry;
  bool _expiredVisibility = false;
  bool _expiryDateVisibility = true;
  bool _checked = false;
  StoreController sc = StoreController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.ingredientName);
    _quantityController = TextEditingController(text: widget.chosenQuantity);
    _alertExpiry = widget.expiryDate;
    _checkExpiry(widget.expiryDate);
    _setTextColor(widget.expiryDate);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  _setTextColor(DateTime expiryDate) {
    var now = DateTime.now();

    if (int.parse(expiryDate.day.toString()) - int.parse(now.day.toString()) <=
        3) {
      return Colors.red;
    } else {
      return Colors.black87;
    }
  }

  _checkExpiry(DateTime expiryDate) {
    var now = DateTime.now();
    if (now.isAfter(expiryDate)) {
      setState(() {
        _expiryDateVisibility = false;
        _expiredVisibility = true;
      });
    } else {
      setState(() {
        _expiryDateVisibility = true;
        _expiredVisibility = false;
      });
    }
  }

  _deleteConfirmation(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Are you sure you want to delete this ingredient?",
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
                      child: Text('ok'),
                      onPressed: () {
                        // if (globals.finalIngredients.length > 0) {
                        //   print("inside deleted if");
                        //   globals.deletedIndex.add(widget.cfmIndex);
                        // }
                        sc.deleteIngredient(widget.ingredientID);
                        // setState(() {
                        //   print("setting " + widget.ingredientName + " to non visible");
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

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _alertExpiry = selectedDate;
        _checkExpiry(_alertExpiry);
        _setTextColor(_alertExpiry);
        if (globals.finalIngredients.length > 0) {
          globals.finalIngredients.elementAt(widget.cfmIndex)['expiryDate'] =
              selectedDate;
        }
      });
    }
  }

  _editNameAndExpiry(BuildContext context) {
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
                              widget.ingredientName = newName;
                              if (globals.finalIngredients.length > 0) {
                                globals.finalIngredients
                                        .elementAt(widget.cfmIndex)['name'] =
                                    newName;
                              }
                            });
                          },
                          controller: _nameController),
                      Divider(
                        height: 20,
                      ),
                      Text("Please input quantity:",
                          style: Theme.of(context).textTheme.bodyText2),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                onChanged: (newQuantity) {
                                  setState(() {
                                    widget.chosenQuantity = newQuantity;
                                    if (globals.finalIngredients.length > 0) {
                                      globals.finalIngredients.elementAt(
                                              widget.cfmIndex)['quantity'] =
                                          int.parse(newQuantity);
                                    }
                                  });
                                },
                                controller: _quantityController,
                              ),
                            ),
                            DropdownButton<String>(
                              value: widget.chosenUnit,
                              items: <String>['g', 'kg', 'ml', 'litre', 'units']
                                  .map<DropdownMenuItem<String>>((String qty) {
                                return DropdownMenuItem<String>(
                                  value: qty,
                                  child: Text(qty,
                                      style:
                                          Theme.of(context).textTheme.caption),
                                );
                              }).toList(),
                              onChanged: (String unit) {
                                setState(() {
                                  widget.chosenUnit = unit;
                                  if (globals.finalIngredients.length > 0) {
                                    globals.finalIngredients.elementAt(
                                        widget.cfmIndex)['metric'] = unit;
                                    ;
                                  }
                                });
                              },
                            ),
                          ]),
                      Divider(
                        height: 20,
                      ),
                      Text("Please input expiry date of item:",
                          style: Theme.of(context).textTheme.bodyText2),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('$_expiry',
                                style: Theme.of(context).textTheme.caption),
                            Text(DateFormat('yyyy-MM-dd').format(_alertExpiry),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: _setTextColor(_alertExpiry))),
                            IconButton(
                              icon: Icon(
                                Icons.calendar_today,
                                color: Theme.of(context).accentColor,
                              ),
                              onPressed: () => _selectDate(context),
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
                          sc.updateIngredient(
                              ingredientId: widget.ingredientID,
                              ingredientDetails: {
                                "name": _nameController.text,
                                "quantity": int.parse(_quantityController.text),
                                "expiryDate": _alertExpiry,
                                "metric": widget.chosenUnit
                              });
                          _nameController.clear();
                          _quantityController.clear();
                          setState(() {
                            widget.expiryDate = _alertExpiry;
                            _checkExpiry(widget.expiryDate);
                            _setTextColor(widget.expiryDate);
                          });
                          Navigator.pop(context);
                        }),
                  ],
                )
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Flexible(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Visibility(
                    child: Checkbox(
                        activeColor: Theme.of(context).primaryColor,
                        value: widget.selectAll ? widget.selectAll : _checked,
                        onChanged: (value) {
                          if (value) {
                            _checked = true;
                          }
                          setState(() {
                            if (value) {
                              if (!globals.selectedIngredients
                                  .contains(widget.ingredientName)) {
                                globals.selectedIngredients
                                    .add(widget.ingredientName);
                                // print(globals.selectedIngredients);
                              }
                            } else {
                              if (globals.selectedIngredients
                                  .contains(widget.ingredientName)) {
                                globals.selectedIngredients
                                    .remove(widget.ingredientName);
                              }
                            }
                          });
                        }),
                    visible: widget.checkboxVisibility,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.15,
                    // padding: EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(widget.ingredientName,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: _setTextColor(widget.expiryDate))),
                          ),
                          Padding(padding: EdgeInsets.all(2)),
                          Visibility(
                            child: Row(children: [
                              Flexible(
                                child: Text(_expiry,
                                    style: Theme.of(context).textTheme.caption),
                              ),
                              Flexible(
                                child: Text(
                                    DateFormat('yyyy-MM-dd')
                                        .format(widget.expiryDate),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            _setTextColor(widget.expiryDate))),
                              ),
                            ]),
                            visible: _expiryDateVisibility,
                          ),
                          Visibility(
                            child: Text(
                              "Expired",
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            ),
                            visible: _expiredVisibility,
                          ),
                        ]),
                  ),
                  Text(widget.chosenQuantity,
                      style: Theme.of(context).textTheme.bodyText2),
                  Text(widget.chosenUnit,
                      style: Theme.of(context).textTheme.bodyText2),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () {
                      _editNameAndExpiry(context);
                    },
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).accentColor,
                      ),
                      onPressed: () {
                        _deleteConfirmation(context);
                      }),
                ]),
          )
        ]),
        visible: _visibilityTag);
  }
}
