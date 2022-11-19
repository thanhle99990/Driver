import 'package:flutter/material.dart';
import 'package:provider_arc/ui/shared/text_styles.dart';

// ignore: camel_case_types
class subHeaderWidget extends StatelessWidget {
  final String title;

  const subHeaderWidget({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Text(title, style: subHeaderStyle),
        ],
      ),
    );
  }
}
