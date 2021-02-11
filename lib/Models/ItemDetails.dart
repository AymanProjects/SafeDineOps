import 'package:flutter/foundation.dart';
import 'AddOn.dart';
import 'FoodItem.dart';

class ItemDetails with ChangeNotifier {
  FoodItem _item;
  List<AddOn> _selectedAddOns;
  int _quantity;

  ItemDetails({FoodItem item, int quantity = 1, List<AddOn> selectedAddOns}) {
    this._item = item;
    this._quantity = quantity;
    this._selectedAddOns = selectedAddOns;
  }

  Map<String, dynamic> toJson() {
    return {
      'item': getItem().toJson(),
      'quantity': getQuantity(),
      'selectedAddOns': getSelectedAddOns().map((addon) {
        return addon?.toJson();
      }).toList(),
    };
  }

  ItemDetails fromJson(Map json) {
    if (json == null) return ItemDetails();
    return new ItemDetails(
      item: FoodItem().fromJson(json['item'] ?? {}),
      quantity: json['quantity'],
      selectedAddOns: json['selectedAddOns']?.map<AddOn>((json) {
        return AddOn().fromJson(json);
      })?.toList(),
    );
  }

  FoodItem getItem() => _item ?? (_item = FoodItem());
  int getQuantity() => _quantity ?? 1;
  List<AddOn> getSelectedAddOns() => _selectedAddOns ?? (_selectedAddOns = []);

  addSelectedAddOn(AddOn addon) {
    _selectedAddOns.add(addon);
    notifyListeners();
  }

  removeSelectedAddOn(AddOn addon) {
    _selectedAddOns.remove(addon);
    notifyListeners();
  }

  setItem(FoodItem item) {
    _item = item;
  }

  setQuantity(int value) {
    _quantity = value;
  }

  setSelectedAddOns(List<AddOn> addOns) {
    _selectedAddOns = addOns;
  }

  increaseQuantityBy(int value) {
    _quantity += value;
    notifyListeners();
  }

  decreaseQuantityByOne() {
    if (_quantity > 1) _quantity--;
    notifyListeners();
  }

  double getTotalSelectionPrice() {
    double addOnsPrice = 0.00;
    for (AddOn addon in getSelectedAddOns()) addOnsPrice += addon.getPrice();

    return (getItem().getPrice() + addOnsPrice) * getQuantity();
  }
}
