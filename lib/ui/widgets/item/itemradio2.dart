import 'package:flutter/material.dart';
import 'package:provider_arc/ui/shared/app_colors.dart';

import '../dummy.dart';

class RadioItem2 extends StatelessWidget {
  final RadioModel2 item;
  final GestureTapCallback onPressed;

  RadioItem2({Key key, this.item, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlatButton(
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(item.img),
            item.isSelected
                ? Text(
                    item.time,
                    style: TextStyle(fontSize: 15, color: PrimaryColor),
                  )
                : Text(
                    item.time,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
            item.isSelected
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      thickness: 5,
                      color: Colors.red,
                    ),
                  )
                : Dummy()
          ],
        ),
      ),
    );
  }
}

class RadioModel2 {
  bool isSelected;
  String time;
  String img;

  RadioModel2(this.isSelected, this.time, this.img);
}
