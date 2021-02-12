import 'dart:io';
import 'package:SafeDineOps/Admin_Screens/ManageMenu/widgets/AddOnsList.dart';
import 'package:SafeDineOps/Models/Category.dart';
import 'package:SafeDineOps/Models/FoodItem.dart';
import 'package:SafeDineOps/Models/Restaurant.dart';
import 'package:SafeDineOps/Services/FirebaseException.dart';
import 'package:SafeDineOps/Services/FirebaseStorage.dart';
import 'package:SafeDineOps/Utilities/Validations.dart';
import 'package:SafeDineOps/Widgets/BorderedButton.dart';
import 'package:SafeDineOps/Widgets/GlobalScaffold.dart';
import 'package:SafeDineOps/Widgets/SafeDineField.dart';
import 'package:SafeDineOps/Widgets/SafeDineSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddItemScreen extends StatefulWidget {
  final Category category;
  final Function updateParent;
  AddItemScreen(this.category, this.updateParent);

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  File _imageFile;
  final picker = ImagePicker();
  FoodItem foodItem = FoodItem();
  bool _loading = false;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GlobalScaffold(
          hasDrawer: false,
          title: 'Add Item in ${widget.category.getName()} category',
          body: Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _field(
                        context: context,
                        hint: 'Item name',
                        validator: (val) => Validations.isEmptyValidation(val),
                        onChanged: (value) => foodItem.setName(value),
                      ),
                      SizedBox(height: 20),
                      _field(
                        context: context,
                        hint: 'Description',
                        validator: (val) => Validations.isEmptyValidation(val),
                        maxLines: 3,
                        onChanged: (value) => foodItem.setDescription(value),
                      ),
                      SizedBox(height: 20),
                      _itemImage(),
                      SizedBox(height: 20),
                      _field(
                        context: context,
                        isNumber: true,
                        hint: 'Price',
                        validator: (String val) {
                          return (double.tryParse(val) == null)
                              ? 'must be in the format of 0.00'
                              : null;
                        },
                        onChanged: (value) =>
                            foodItem.setPrice(double.tryParse(value)),
                      ),
                      AddOnsList(
                        addons: foodItem.getAddOns(),
                      ),
                      SizedBox(height: 20),
                      BorderedButton(
                        text: 'Add Item',
                        function: () async {
                          setState(() {
                            _loading = true;
                          });
                          if (_formKey.currentState.validate()) {
                            if (_imageFile != null) {
                              String url =
                                  await CloudStorage.uploadFile(_imageFile);
                              foodItem.setUrl(url);
                            }
                            try {
                              widget.category.getItems().add(foodItem);
                              await Provider.of<Restaurant>(
                                context,
                                listen: false,
                              ).updateOrCreate();
                              widget.updateParent();
                              Navigator.pop(context);
                            } on PlatformException catch (exception) {
                              SafeDineSnackBar.showNotification(
                                type: SnackbarType.Error,
                                context: context,
                                msg: FirebaseException.generateReadableMessage(
                                    exception),
                              );
                            }
                          }
                          setState(() {
                            _loading = false;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        _loading
            ? Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black26,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                    backgroundColor: Colors.white,
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }

  Widget _field({
    Function onChanged,
    context,
    String hint,
    int maxLines = 1,
    bool isNumber = false,
    Function validator,
  }) {
    return SafeDineField(
      color: Colors.grey[300],
      isNumber: isNumber,
      validator: validator,
      hintText: hint,
      maxLines: maxLines,
      enabled: true,
      onChanged: (value) {
        if (onChanged != null) onChanged(value);
      },
    );
  }

  Widget _itemImage() {
    return InkWell(
      onTap: () => getImage(),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(6),
        ),
        height: 150,
        width: double.infinity,
        child: _imageFile == null
            ? Icon(
                Icons.add_photo_alternate_rounded,
                color: Colors.grey[400],
                size: 100,
              )
            : Image.file(_imageFile, fit: BoxFit.cover),
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }
}
