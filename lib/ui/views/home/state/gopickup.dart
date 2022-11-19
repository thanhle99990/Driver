import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:mdi/mdi.dart';
import 'package:provider_arc/core/constants/enum.dart';
import 'package:provider_arc/core/models/reason.dart';
import 'package:provider_arc/core/models/userobj.dart';
import 'package:provider_arc/core/utils/log.dart';
import 'package:provider_arc/core/viewmodels/views/map_view_model.dart';
import 'package:provider_arc/ui/shared/app_colors.dart';
import 'package:provider_arc/ui/shared/text_styles.dart';
import 'package:provider_arc/ui/shared/ui_helpers.dart';
import 'package:provider_arc/ui/views/chat/chat_screen.dart';
import 'package:provider_arc/ui/widgets/custom/mybutton.dart';
import 'package:provider_arc/ui/widgets/custom/mycontainer.dart';
import 'package:url_launcher/url_launcher.dart';

class GoPickup extends StatefulWidget {
  final MapViewModel model;

  const GoPickup({Key key, this.model}) : super(key: key);

  @override
  _GoPickupState createState() => _GoPickupState(model);
}

class _GoPickupState extends State<GoPickup> {
  final MapViewModel model;
  bool google = false;
  bool yandex = false;
  bool waze = false;

  bool show = false;
  int select = 0;

  _GoPickupState(this.model);

  @override
  Widget build(BuildContext context) {
    return show
        ? buildConfirm()
        : Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.white,
                  child: ListTile(
                    /*leading: Transform.scale(
                  scale: 2 / 3, child: Image.asset('assets/icons/icopass.png')),*/
                    title: Text(
                      "${model.rideObj.from}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    /*trailing: AvatarGlow(
                      endRadius: 48.0,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: PrimaryColor,
                          shape: CircleBorder(),
                        ),
                        child: Icon(
                          Icons.navigation,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          launchWaze(
                              model.rideObj.fromlat, model.rideObj.fromlng);
                        },
                      ),
                    ),*/
                    trailing: CircleAvatar(
                      child: AvatarGlow(
                        endRadius: 48.0,
                        child: IconButton(
                          onPressed: () {
                            launchWaze(
                                model.rideObj.fromlat, model.rideObj.fromlng);
                          },
                          icon: Icon(
                            Icons.navigation,
                            color: Colors.white,
                          ),
                        ),
                      ),
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
                          model.driverStatus == DriverStatus.gotopickup
                              ? "Go to pickup"
                              : "Arrived",
                          style: TitleStyle,
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Item2(
                          icon: LineAwesomeIcons.close,
                          text: "Cancel",
                          onPressed: () {
                            setState(() {
                              show = !show;
                            });
                          },
                        ),
                        Item2(
                          icon: LineAwesomeIcons.wechat,
                          text: "Message",
                          onPressed: () {
                            UserObj item = UserObj();
                            item.iddriver = model.currCustomer.idcustomer;
                            item.name = model.currCustomer.name;
                            item.phone = model.currCustomer.phone;
                            item.profile = model.currCustomer.profile;
                            item.token = model.currCustomer.token;
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                          userObj: item,
                                        )));
                          },
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
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: model.driverStatus == DriverStatus.gotopickup
                          ? MyButton(
                              caption: "ARRIVED",
                              fullsize: true,
                              onPressed: () {
                                model.arrived();
                              },
                            )
                          : MyButton(
                              caption: "START RIDE",
                              fullsize: true,
                              onPressed: () {
                                model.beginRide();
                              },
                            ),
                    )
                  ],
                ),
              )
            ],
          );
  }

  Widget buildConfirm() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  show = false;
                });
              },
            ),
            title: Text(
              "Cancel Trip",
              style: BoldStyle,
            ),
          ),
          Divider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: model.listReason.length,
                itemBuilder: (context, index) {
                  ReasonObj item = model.listReason[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        select = index;
                      });
                    },
                    child: select == index
                        ? ListTile(
                            leading: Icon(
                              Mdi.checkboxMarkedCircle,
                              color: PrimaryColor,
                            ),
                            title: Text(item.description))
                        : ListTile(
                            leading: Icon(Mdi.checkboxBlankCircleOutline),
                            title: Text(item.description)),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyButton(
              caption: "Done",
              fullsize: true,
              onPressed: () {
                Log.info('click');
                model.cancelRide(model.listReason[select].idreason);
              },
            ),
          )
        ],
      ),
    );
  }

  void launchWaze(double lat, double lng) async {
    var url =
        'https://www.google.com/maps/search/?api=1&query=${lat.toString()},${lng.toString()}&navigate=yes';
    var fallbackUrl =
        'https://www.google.com/maps/search/?api=1&query=${lat.toString()},${lng.toString()}&navigate=yes';
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
        child: Row(
          children: <Widget>[
            Icon(icon),
            UIHelper.horizontalSpaceSmall,
            Text(text)
          ],
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
