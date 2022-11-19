import 'package:flutter/material.dart';
import 'package:provider_arc/ui/shared/text_styles.dart';

class MyTitle extends StatelessWidget {
  final String title;

  const MyTitle({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    );
  }
}
class MyH1 extends StatelessWidget {
  final String text;

  const MyH1({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(text,style: H1,);
  }
}
class MyH2 extends StatelessWidget {
  final String text;

  const MyH2({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(text,style: H2,);
  }
}

class MyH3 extends StatelessWidget {
  final String text;

  const MyH3({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(text,style: H3,);
  }
}