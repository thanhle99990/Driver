import 'package:flutter/material.dart';
import 'package:provider_arc/ui/shared/app_colors.dart';
class MyButtonO extends StatelessWidget {
  final String caption;
  final GestureTapCallback onPressed;
  final Color color;

  MyButtonO({Key key, this.caption, this.onPressed, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: double.infinity,
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
          side: BorderSide(
            color: Colors.white,
            width: 1.0,
          ),
        ),
        textColor: PrimaryColor,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
        onPressed: onPressed,
        child: Text(
          caption,
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
