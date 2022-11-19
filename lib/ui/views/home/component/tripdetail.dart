import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider_arc/ui/shared/app_colors.dart';
import 'package:provider_arc/ui/widgets/others/item1.dart';

class TripDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: LightBlue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Item1(
            icon: FontAwesomeIcons.route,
            text: "8 Km",
          ),
          Item1(
            icon: FontAwesomeIcons.clock,
            text: "30 Min",
          ),
          Item1(
            icon: FontAwesomeIcons.dollarSign,
            text: "Free",
          ),
        ],
      ),
    );
  }
}
