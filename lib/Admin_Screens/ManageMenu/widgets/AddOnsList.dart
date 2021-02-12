import 'package:flutter/material.dart';
import '../../../Models/AddOn.dart';

class AddOnsList extends StatefulWidget {
  final List<AddOn> addons;
  AddOnsList({this.addons});
  @override
  _AddOnsListState createState() => _AddOnsListState();
}

class _AddOnsListState extends State<AddOnsList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Add-ons",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Spacer(),
            IconButton(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerRight,
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  widget.addons.add(AddOn());
                });
              },
            ),
          ],
        ),
        ...widget.addons.map((addon) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _field(
                      context: context,
                      hint: 'Name...',
                      onChanged: (name) {
                        addon.setName(name);
                      },
                      validator: (String val) {
                        if (val.isEmpty) {
                          return '';
                        } else {
                          return null;
                        }
                      }),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: _field(
                    context: context,
                    hint: '0.00',
                    onChanged: (price) {
                      addon.setPrice(double.tryParse(price));
                    },
                    validator: (String val) {
                      return (double.tryParse(val) == null) ? '' : null;
                    },
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerRight,
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      widget.addons.remove(addon);
                    });
                  },
                ),
              ],
            ),
          );
        }).toList(),
      ],
      // shrinkWrap: true,
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
    return TextFormField(
      decoration: InputDecoration(
        errorStyle: TextStyle(height: 0),
        hintText: hint,
        errorMaxLines: 1,
        hintMaxLines: 1,
        contentPadding: EdgeInsets.all(16.0),
        filled: true,
        fillColor: Colors.grey[300],
        enabledBorder: border(),
        focusedBorder: border(),
        errorBorder: border().copyWith(
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        disabledBorder: border(),
        focusedErrorBorder: border(),
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: validator,
      maxLines: maxLines,
      enabled: true,
      onChanged: (value) {
        if (onChanged != null) onChanged(value);
      },
    );
  }

  OutlineInputBorder border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(
        color: Colors.transparent,
        width: 0.5,
        style: BorderStyle.solid,
      ),
    );
  }
}
