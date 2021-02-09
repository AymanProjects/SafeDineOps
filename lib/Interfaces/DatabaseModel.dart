abstract class DatabaseModel{
  String id;
  DatabaseModel fromJson(Map json);
  Map toJson();
  Future fetch(String id);
  Future updateOrCreate();
  String getID();
  void setID(String id);
}