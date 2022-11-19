import 'package:flutter/material.dart';

class Item3 extends StatelessWidget {
  final IconData icon;
  final String text;

  const Item3({Key key, this.icon, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          size: 16,
        ),
        SizedBox(
          width: 8,
        ),
        Text("$text")
      ],
    );
  }
}
