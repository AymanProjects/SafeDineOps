import 'FoodItem.dart';

class Category {
  String _name;
  List<FoodItem> _items;

  Category({String name, List<FoodItem> items}) {
    this._name = name;
    this._items = items;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': getName(),
      'items': getItems().map((item) {
        return item?.toJson();
      }).toList(),
    };
  }

  Category fromJson(Map json) {
    if (json == null) return Category();
    return new Category(
      name: json['name'],
      items: json['items']?.map<FoodItem>((json) {
        return FoodItem().fromJson(json);
      })?.toList(),
    );
  }

  List<FoodItem> getItems() => _items ?? (_items = []);
  String getName() => _name ?? 'Unnamed category';

  setAddOns(List<FoodItem> value) {
    _items = value;
  }

  setName(String value) {
    _name = value;
  }
}
