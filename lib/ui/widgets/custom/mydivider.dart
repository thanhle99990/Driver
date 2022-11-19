import 'package:flutter/material.dart';

// ignore: camel_case_types
class myDivider extends StatelessWidget {
  const myDivider({
    Key key,

  }) : super(key: key);

  final Color divider = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: divider,
    );
  }
}
