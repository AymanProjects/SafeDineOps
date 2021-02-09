import 'AddOn.dart';

class FoodItem {
  String _name;
  double _price;
  String _description;
  List<AddOn> _addOns;
  String _imageUrl;

  FoodItem(
      {String name,
      double price,
      String description,
      List<AddOn> addOns,
      imageUrl}) {
    this._name = name;
    this._price = price;
    this._description = description;
    this._addOns = addOns;
    this._imageUrl = imageUrl;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': getName(),
      'price': getPrice(),
      'description': getDescription(),
      'addOns': getAddOns().map((addon) {
            return addon?.toJson();
          }).toList(),
      'imageUrl': getUrl(),
    };
  }

  FoodItem fromJson(Map json) {
    if (json == null) return FoodItem();
    return new FoodItem(
      name: json['name'],
      price: json['price'] + .0, // convert to double if it was int
      description: json['description'],
      addOns: json['addOns']?.map<AddOn>((json) {
            return AddOn().fromJson(json);
          })?.toList(),
      imageUrl: json['imageUrl'],
    );
  }

  List<AddOn> getAddOns() => _addOns ?? [];
  String getDescription() => _description ?? 'No Additional Info.';
  double getPrice() => _price ?? 0.00;
  String getName() => _name ?? 'Unnamed Item';
  String getUrl() => _imageUrl ?? 'https://www.theemailcompany.com/wp-content/uploads/2016/02/no-image-placeholder-big.jpg';

  setAddOns(List<AddOn> value) {
    _addOns = value;
  }

  setDescription(String value) {
    _description = value;
  }

  setPrice(double value) {
    _price = value;
  }

  setName(String value) {
    _name = value;
  }

  setUrl(String value) {
    _imageUrl = value;
  }
}
