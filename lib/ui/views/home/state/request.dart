import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:provider_arc/core/models/reason.dart';
import 'package:provider_arc/core/viewmodels/views/map_view_model.dart';
import 'package:provider_arc/ui/shared/app_colors.dart';
import 'package:provider_arc/ui/shared/text_styles.dart';
import 'package:provider_arc/ui/shared/ui_helpers.dart';
import 'package:provider_arc/ui/widgets/custom/mybutton.dart';
import 'package:provider_arc/ui/widgets/custom/mycontainer.dart';
import 'package:provider_arc/ui/widgets/fromto2.dart';
import 'package:provider_arc/ui/widgets/loading.dart';
import 'package:provider_arc/ui/widgets/my/star.dart';
import 'package:provider_arc/ui/widgets/mylocation.dart';

class Request extends StatefulWidget {
  final MapViewModel model;

  const Request({Key key, this.model}) : super(key: key);

  @override
  _RequestState createState() => _RequestState(model);
}

class _RequestState extends State<Request> {
  final MapViewModel model;
  Timer _timer;
  int _start = 30;
  bool show = false;
  int select = 0;

  /* List<String> list = [
    'Rider is not here',
    'Wrong address shown',
    'Don\'t charge rider',
    'Don\'t charge rider',
    'Don\'t charge rider',
    'Don\'t charge rider'
  ];
*/
  _RequestState(this.model);

  @override
  // ignore: must_call_super
  void initState() {
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return show
        ? buildConfirm()
        : Column(
            children: <Widget>[
              UIHelper.verticalSpaceSmall,
              FlatButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(24.0)),
                color: Colors.white,
                textColor: Colors.black,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                padding: EdgeInsets.fromLTRB(32, 12, 32, 12),
                onPressed: () {
                  setState(() {
                    show = true;
                  });
                },
                label: Text(
                  "No Thanks",
                  style: TextStyle(color: PrimaryColor, fontSize: 18),
                ),
                icon: Icon(
                  Icons.close,
                  color: PrimaryColor,
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyLocation(
                      model: model,
                    ),
                  )
                ],
              ),
              MyContainer(
                child: Column(
                  children: <Widget>[
                    UIHelper.verticalSpaceSmall,
                    model.currCustomer == null
                        ? Loading()
                        : ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage("${model.currCustomer.profile}"),
                              radius: 20.0,
                            ),
                            title: Text(
                              "${model.currCustomer.name}",
                              style: BoldStyle,
                            ),
                            /*subtitle: Star(
                              rating: model.currCustomer.rating,
                            ),*/
                            trailing: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    model.rideObj.price.toStringAsFixed(1) +
                                        "\$",
                                    style: TitleStyle,
                                  ),
                                  model.rideObj == null
                                      ? Loading()
                                      : Text(
                                          "${model.rideObj.kmtext}   ${model.rideObj.timetext}")
                                ],
                              ),
                            ),
                          ),
                    Divider(
                      height: 1,
                    ),
                    model.rideObj == null
                        ? Loading()
                        : FromTo2(
                            from: "${model.rideObj.from}",
                            to: "${model.rideObj.to}",
                          ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Stack(
                        children: <Widget>[
                          MyButton(
                            caption: "TAP TO ACCEPT",
                            fullsize: true,
                            onPressed: () {
                              model.accept();
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  child: Text(
                                    "$_start",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.amber,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
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
                model.cancelRide(model.listReason[select].idreason);
              },
            ),
          )
        ],
      ),
    );
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            model.reject();
            /*setState(() {
              show = true;
            });*/
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }
}
