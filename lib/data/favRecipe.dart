import 'package:cloud_firestore/cloud_firestore.dart';

class FavRecipe {
  final int recipeID;
  final String title;
  final String docID;
  static CollectionReference _favRecipes =
      FirebaseFirestore.instance.collection('favRecipes');

  FavRecipe({this.title, this.recipeID, this.docID});

  String getTitle() {
    return title;
  }

  // String getId() {
  //   return id;
  // }

  factory FavRecipe.createFavRecipeFromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();

    FavRecipe x = FavRecipe(
        title: data['title'] ?? "", recipeID: data['recipeID'], docID: doc.id);
    return x;
  }

  static Stream<List<FavRecipe>> getFavRecipes(String uid) {
    return _favRecipes
        .where('userID', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return FavRecipe.createFavRecipeFromFirestore(doc);
      }).toList();
    });
  }
}
