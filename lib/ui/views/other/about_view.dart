import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:mdi/mdi.dart';
import 'package:provider_arc/ui/shared/ui_helpers.dart';

class AboutPage extends KFDrawerContent {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  child: Material(
                    shadowColor: Colors.transparent,
                    color: Colors.transparent,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      onPressed: widget.onMenuPressed,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  UIHelper.verticalSpaceSmall,
                  ListTile(
                    title: Text('+84.939170707'),
                    subtitle: Text("Whatsapp"),
                    leading: Icon(FontAwesomeIcons.whatsapp),
                  ),
                  ListTile(
                    title: Text('jeetebe@gmail.com'),
                    leading: Icon(Mdi.email),
                  ),
                  ListTile(
                    title: Text('https://apptot.vn'),
                    leading: Icon(Mdi.web),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
