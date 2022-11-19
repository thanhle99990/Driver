import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';
import 'package:provider_arc/core/models/userobj.dart';
import 'package:provider_arc/core/viewmodels/views/map_view_model.dart';
import 'package:provider_arc/ui/shared/app_colors.dart';
import 'package:provider_arc/ui/shared/text_styles.dart';
import 'package:provider_arc/ui/shared/ui_helpers.dart';
import 'package:provider_arc/ui/widgets/dummy.dart';
import 'package:provider_arc/ui/widgets/mylocation.dart';
import 'package:url_launcher/url_launcher.dart';

class None extends StatelessWidget {
  final MapViewModel model;
  final GestureTapCallback onMenuPressed;
  final GestureTapCallback socketSend;

  const None({Key key, this.model, this.onMenuPressed, this.socketSend})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserObj driver = Provider.of<UserObj>(context);
    return driver == null
        ? Dummy()
        : Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 16),
                    child: IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.black,
                        size: 40,
                      ),
                      onPressed: onMenuPressed,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, right: 16),
                    child: MyLocation(
                      model: model,
                    ),
                  )
                ],
              ),
              Spacer(),
              /*Align(
                alignment: Alignment.centerRight,
                child: FlatButton.icon(
                    onPressed: _whatsapp,
                    icon: Icon(
                      Mdi.whatsapp,
                      color: Colors.green,
                    ),
                    label: Text(
                      "BUY",
                      style: TextStyle(color: Colors.green),
                    )),
              )*/
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      color: LightColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                UIHelper.horizontalSpaceSmall,
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage("${driver.profile}"),
                                  radius: 20.0,
                                ),
                                UIHelper.horizontalSpaceSmall,
                                Text(
                                  "${driver.name}",
                                  style: BoldStyle,
                                ),
                              ],
                            ),
                          ),
                          model.userObj == null
                              ? Dummy()
                              : Row(
                                  children: <Widget>[
                                    Transform.scale(
                                      scale: 2 / 3,
                                      child: LiteRollingSwitch(
                                        //initial value
                                        value: model.userObj.online == 1,
                                        textOn: 'Online',
                                        textOff: 'Offline',
                                        colorOn: PrimaryColor,
                                        colorOff: Grey,
                                        iconOn: Icons.done,
                                        iconOff: Icons.remove_circle_outline,
                                        textSize: 16.0,
                                        onChanged: (bool state) {
                                          //Use it to manage the different states
                                          print(
                                              'Current State of SWITCH IS: $state');
                                          if (state) {
                                            model.updateOnline(1); // send message online
                                          } else {
                                            model.updateOnline(0);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                    ),
                    model.userObj == null
                        ? Dummy()
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Item1(
                                    icon: Icons.local_taxi,
                                    title: "Rides",
                                    value: model.numRide == null
                                        ? '0'
                                        : model.numRide.toString()),
                                Item1(
                                    icon: Icons.stars,
                                    title: "Rating",
                                    value: model.userObj.rating == null
                                        ? '-'
                                        : model.userObj.rating == 0.0
                                            ? '-'
                                            : model.userObj.rating
                                                .toStringAsFixed(1)),
                                Item1(
                                  icon: Icons.monetization_on,
                                  title: "Earning",
                                  value: model.earning.toString() + "\$",
                                ),
                              ],
                            ),
                          )
                  ],
                ),
              )
            ],
          );
  }

  Future<void> _whatsapp() async {
    String url = "whatsapp://send?phone=84939170707";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class Item1 extends StatelessWidget {
  final IconData icon;
  final String value;
  final String title;

  const Item1({Key key, this.icon, this.value, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(
          icon,
          color: PrimaryColor,
        ),
        Text(
          value,
          style: TitleStyle,
        ),
        Text(
          title,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
