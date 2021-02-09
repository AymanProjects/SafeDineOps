import 'package:SafeDineOps/Interfaces/DatabaseModel.dart';
import 'package:SafeDineOps/Models/Branch.dart';
import 'package:SafeDineOps/Models/Order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class Database {
  Database._();
  static String visitorsCollection = 'visitors';
  static String restaurantsCollection = 'restaurants';
  static String branchesCollection = 'branches';
  static String ordersCollection = 'orders';

  static Future<DocumentSnapshot> getDocument(
      String id, String collectionName) async {
    if (id == null || id.isEmpty) // id should neither be embty nor null
      throw new PlatformException(code: "Document not found");
    return await Firestore.instance
        .collection(collectionName)
        .document(id)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists)
        return doc;
      else
        throw new PlatformException(code: "Document not found");
    });
  }

  static Future<void> setDocument(
      DatabaseModel model, String collectionName) async {
    // 1. if object.id is null, this will generate a new id
    DocumentReference reference =
        Firestore.instance.collection(collectionName).document(model.id);
    // 2. assign the new id. If object.id was not null then object.id would already equal reference.documentID
    // so this line has no effect if object.id was not null
    model.id = reference.documentID;
    // 3. create or update
    await Firestore.instance
        .collection(collectionName)
        .document(model.id)
        .setData(model.toJson(), merge: true);
  }

  static Future<void> deleteDocument(String id, String collectionName) async {
    await Firestore.instance.collection(collectionName).document(id).delete();
  }

  static Stream<List<Order>> getOrdersOfVisitorWhere(
      {String status, String visitorID}) {
    return Firestore.instance
        .collection(ordersCollection)
        .where('visitorID', isEqualTo: visitorID)
        .where('status', isEqualTo: status)
        .orderBy('date', descending: true)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.documents.map((doc) {
        return Order().fromJson(doc.data);
      }).toList();
    });
  }

  static Stream<List<Order>> getAllOrdersOfVisitor({String visitorID}) {
    return Firestore.instance
        .collection(ordersCollection)
        .where('visitorID', isEqualTo: visitorID)
        .orderBy('date', descending: true)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.documents.map((doc) {
        return Order().fromJson(doc.data);
      }).toList();
    });
  }

  static Future<List<Branch>> getBranchesOfRestaurant(String restaurantID) async {
    List<Branch> branches = await Firestore.instance
        .collection(branchesCollection)
        .where('restaurantID', isEqualTo: restaurantID)
        .getDocuments()
        .then((QuerySnapshot queryResult) {
      if (queryResult.documents.isNotEmpty)
        return queryResult.documents.map((DocumentSnapshot document) {
          return Branch().fromJson(document.data);
        }).toList();
      else
        return [];
    });
    return branches;
  }
}
