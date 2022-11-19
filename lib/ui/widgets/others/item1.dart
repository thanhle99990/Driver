import 'package:flutter/material.dart';
import 'package:provider_arc/ui/shared/app_colors.dart';
import 'package:provider_arc/ui/shared/ui_helpers.dart';

class Item1 extends StatelessWidget {
  final IconData icon;
  final String text;

  const Item1({Key key, this.icon, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    icon,
                    size: 20,
                    color: PrimaryColor,
                  ),
                ))),
        UIHelper.horizontalSpaceSmall,
        Text(
          text,
          //style: TextStyle(fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
