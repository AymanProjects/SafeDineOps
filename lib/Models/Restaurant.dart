import 'package:SafeDineOps/Models/Account.dart';
import 'package:SafeDineOps/Services/Authentication.dart';
import 'package:SafeDineOps/Services/Database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import '../Interfaces/DatabaseModel.dart';
import 'Branch.dart';
import 'Category.dart';

class Restaurant extends Account implements DatabaseModel {
  List<Category> _menu;
  @override
  String id;

  Restaurant(
      {String id,
      String email,
      String password,
      String name,
      List<Category> menu})
      : super(name: name, email: email, password: password) {
    this.id = id;
    this._menu = menu;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': getID(),
      'email': super.getEmail(),
      'name': super.getName(),
      'menu': getMenu()?.map((category) {
        return category?.toJson();
      })?.toList(),
    };
  }

  @override
  Restaurant fromJson(Map json) {
    if (json == null) return Restaurant();
    return new Restaurant(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      menu: json['menu']?.map<Category>((json) {
        return Category().fromJson(json);
      })?.toList(),
    );
  }

  Future<List<int>> createTableQR(Map content) async {
    Response response = await Dio().get(
      "https://api.qrserver.com/v1/create-qr-code/?size=500x500&data=$content",
      options: Options(responseType: ResponseType.bytes),
    );
    return response.data;
  }

  @override
  Future<Restaurant> fetch(String id) async {
    DocumentSnapshot doc =
        await Database.getDocument(id, Database.restaurantsCollection);
    return fromJson(doc.data);
  }

  @override
  Future updateOrCreate() async {
    await Database.setDocument(this, Database.restaurantsCollection);
  }

  Future addBranch(Branch branch) async {
    await Database.setDocument(branch, Database.branchesCollection);
  }

  Future deleteBranch(Branch branch) async {
    await Database.deleteDocument(branch.id, Database.branchesCollection);
  }

  @override
  Future<void> login() async {
    return await Authentication.login(this);
  }

  @override
  Future<void> logout() async {
    return await Authentication.signOut();
  }

  @override
  Future<void> register() async {
    return await Authentication.register(this);
  }

  @override
  Future<void> forgotPassword() async {
    await Authentication.forgotPassword(email: getEmail());
  }

  List<Category> getMenu() => _menu ?? (_menu = []);

  setMenu(List<Category> value) {
    _menu = value;
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
