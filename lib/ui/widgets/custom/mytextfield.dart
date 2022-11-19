import 'package:flutter/material.dart';
import 'package:provider_arc/ui/shared/ui_helpers.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controllerText;
 final bool invalid;
  final String name;

  const MyTextField({Key key, this.controllerText, this.name, this.invalid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(name.toUpperCase(), style: TextStyle(color: Colors.grey)),
        UIHelper.verticalSpaceSmall,
        TextField(
          controller: controllerText,
          decoration: InputDecoration(
              errorText:
                  invalid ? 'Value Can\'t Be Empty' : null,
              suffixIcon: GestureDetector(
                onTap: () {
                  print("clear");
                  controllerText.clear();
                },
                child: Icon(
                  Icons.clear,
                  color: Colors.black26,
                ),
              ),
              hintText: name,
              hintStyle: TextStyle(color: Colors.black26),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey, width: 5.0),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)),
        ),
      ],
    );
  }
}
