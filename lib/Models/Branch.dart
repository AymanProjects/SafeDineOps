import 'package:SafeDineOps/Services/Database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Interfaces/DatabaseModel.dart';

class Branch implements DatabaseModel {
  String _restaurantID;
  String _name;
  @override
  String id;

  Branch({String id, String name, String restaurantID}) {
    this._restaurantID = restaurantID;
    this._name = name;
    this.id = id;
  }

  @override
  Future<Branch> fetch(String id) async {
    DocumentSnapshot doc =
        await Database.getDocument(id, Database.branchesCollection);
    return fromJson(doc.data);
  }

  @override
  Future updateOrCreate() async {
    await Database.setDocument(this, Database.branchesCollection);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': getID(),
      'restaurantID': getRestaurantID(),
      'name': getName(),
    };
  }

  @override
  Branch fromJson(Map json) {
    if (json == null) return Branch();
    return new Branch(
      restaurantID: json['restaurantID'],
      name: json['name'],
      id: json['id'],
    );
  }

  String getName() => _name ?? '';
  String getRestaurantID() => _restaurantID ?? '';

  setName(String value) {
    _name = value;
  }

  setRestaurantID(String value) {
    _restaurantID = value;
  }

  @override
  String getID() {
    return id;
  }

  @override
  void setID(String id) {
    this.id = id;
  }
}
