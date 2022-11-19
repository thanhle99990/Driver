import 'package:flutter/material.dart';
import 'package:provider_arc/core/viewmodels/views/map_view_model.dart';
import 'package:provider_arc/ui/shared/app_colors.dart';
import 'package:provider_arc/ui/shared/text_styles.dart';
import 'package:provider_arc/ui/shared/ui_helpers.dart';
import 'package:provider_arc/ui/widgets/custom/mybutton.dart';
import 'package:provider_arc/ui/widgets/custom/mycontainer.dart';
import 'package:url_launcher/url_launcher.dart';

class BeginRide extends StatelessWidget {
  final MapViewModel model;

  const BeginRide({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.white,
            child: ListTile(
              //title: Text("${model.rideObj.to}"),
              title: Text(
                "${model.rideObj.to}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: PrimaryColor,
                  shape: CircleBorder(),
                ),
                child: Icon(
                  Icons.navigation,
                  color: Colors.white,
                ),
                onPressed: () {
                  launchWaze(model.rideObj.tolat, model.rideObj.tolng);
                },
              ),
            ),
          ),
        ),
        Spacer(),
        MyContainer(
          child: Column(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage("${model.currCustomer.profile}"),
                  radius: 20.0,
                ),
                title: Text(
                  "${model.currCustomer.name} ",
                  style: BoldStyle,
                ),
                trailing: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    "Go to destination",
                    style: TitleStyle,
                  ),
                ),
              ),
              Divider(),
              /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Item2(
                    icon: LineAwesomeIcons.close,
                    text: "Cancel",
                    onPressed: () {},
                  ),
                  Item2(
                    icon: LineAwesomeIcons.phone,
                    text: "Call",
                    onPressed: () {
                      print('call click');
                      launch("tel://" + model.currCustomer.phone);
                    },
                  ),
                ],
              ),*/
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyButton(
                  caption: "COMPLETE",
                  fullsize: true,
                  onPressed: () {
                    model.complete();
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  void launchWaze(double lat, double lng) async {
    var url = 'waze://?ll=${lat.toString()},${lng.toString()}';
    var fallbackUrl =
        'https://waze.com/ul?ll=${lat.toString()},${lng.toString()}&navigate=yes';
    try {
      bool launched =
          await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }
}

class Item2 extends StatelessWidget {
  final IconData icon;
  final String text;
  final GestureTapCallback onPressed;

  const Item2({Key key, this.icon, this.text, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Column(
          children: <Widget>[Icon(icon), Text(text)],
        ),
      ),
    );
  }
}

class Item3 extends StatelessWidget {
  final IconData icon;
  final String text;

  const Item3({Key key, this.icon, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon),
        UIHelper.horizontalSpaceSmall,
        Text(
          text,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
