class AddOn {
  String _name;
  double _price;

  AddOn({String name, double price}) {
    this._name = name;
    this._price = price;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': getName(),
      'price': getPrice(),
    };
  }

  AddOn fromJson(Map json) {
    if (json == null) return AddOn();
    return new AddOn(
      name: json['name'],
      price: json['price'] + .0, // convert to double if it was int :)
    );
  }

  double getPrice() => _price ?? 0.00;
  String getName() => _name ?? 'Unnamed';

  setPrice(double value) {
    _price = value;
  }

  setName(String value) {
    _name = value;
  }
}
