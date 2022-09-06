import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_ventures/controllers/authenticationController.dart';

class AppUser {
  final String uid;
  final String email;
  final String displayName;
  static CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  AppUser({this.email, this.displayName, this.uid});

  factory AppUser.createAppuserFromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    AppUser x = AppUser(
        displayName: data['displayName'] ?? '',
        email: data['email'] ?? '',
        uid: doc.id);
    return x;
  }

  static Stream<AppUser> getUserFromID(docID) {
    if (docID == null) {
      return null;
    } else {
      return _users.doc(docID).snapshots().map((doc) {
        return AppUser.createAppuserFromFirestore(doc);
      });
    }
  }

  static Stream<AppUser> getCurrentUser() {
    User currUser = AuthenticationController().getCurrUserFromFirebase();
    return (currUser == null) ? null : getUserFromID(currUser.uid);
  }
}
