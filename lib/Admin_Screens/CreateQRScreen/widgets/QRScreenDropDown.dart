import 'package:SafeDineOps/Models/Branch.dart';
import 'package:flutter/material.dart';

class QRScreenDropDown extends StatefulWidget {
  final List<Branch> branches;
  final Function onChanged;
  QRScreenDropDown({@required this.branches, @required this.onChanged(value)});

  @override
  _QRScreenDropDownState createState() => _QRScreenDropDownState();
}

class _QRScreenDropDownState extends State<QRScreenDropDown> {
  Branch selctedBranch;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(6)),
      child: DropdownButton(
        isExpanded: true,
        underline: SizedBox(),
        icon: Icon(Icons.arrow_drop_down),
        hint: Text('Select Branch'),
        value: selctedBranch,
        onChanged: (Branch newSelectedBranch) {
          selctedBranch = newSelectedBranch;
          widget.onChanged(newSelectedBranch);
          setState(() {});
        },
        items: widget.branches
            .map((branch) => DropdownMenuItem(
                  value: branch,
                  child: Text(branch.getName()),
                ))
            .toList(),
      ),
    );
  }
}
