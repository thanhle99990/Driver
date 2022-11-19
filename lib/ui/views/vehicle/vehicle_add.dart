import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider_arc/core/utils/device_utils.dart';
import 'package:provider_arc/ui/shared/app_colors.dart';
import 'package:provider_arc/ui/shared/text_styles.dart';
import 'package:provider_arc/ui/shared/ui_helpers.dart';
import 'package:provider_arc/ui/widgets/custom/mybuttonfull.dart';

class VehicleAddView extends StatefulWidget {
  @override
  _VehicleAddViewState createState() => _VehicleAddViewState();
}

class _VehicleAddViewState extends State<VehicleAddView> {
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerNumber = new TextEditingController();
  bool invalidName = false;
  bool invalidNumber = false;

  String type = "Sedan";
  String _value;
  int seat = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '',
        ),
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text("Add New Vehicle",
                        style: headerStyle.copyWith(color: Basic)),
                  ),
                  Image.asset(
                    'assets/images/vehicle.png',
                    width: DeviceUtils.getScaledWidth(context, 1),
                    //height: size.height,
                    fit: BoxFit.fill,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Type",
                                    style: BoldStyle,
                                  ),
                                  DropdownButton<String>(
                                    items: [
                                      DropdownMenuItem<String>(
                                        child: Text('Sedan'),
                                        value: 'Sedan',
                                      ),
                                      DropdownMenuItem<String>(
                                        child: Text('SUV'),
                                        value: 'SUV',
                                      ),
                                      DropdownMenuItem<String>(
                                        child: Text('Van'),
                                        value: 'Van',
                                      ),
                                    ],
                                    onChanged: (String value) {
                                      setState(() {
                                        _value = value;
                                      });
                                    },
                                    hint: Text('Sedan'),
                                    value: _value,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Capacity",
                                    style: BoldStyle,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      IconButton(
                                        onPressed: () => {
                                          setState(() {
                                            if (seat > 0) seat--;
                                          })
                                        },
                                        icon: Icon(
                                          Icons.remove_circle,
                                          color: Basic,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Text("$seat"),
                                      ),
                                      IconButton(
                                        onPressed: () => {
                                          setState(() {
                                            if (seat < 21) seat++;
                                          })
                                        },
                                        icon: Icon(
                                          Icons.add_circle,
                                          color: Grey,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        UIHelper.verticalSpaceSmall,
                        Text(
                          "Name",
                          style: BoldStyle,
                        ),
                        TextField(
                            onTap: () {
                              setState(() {
                                invalidName = false;
                                invalidNumber = false;
                              });
                            },
                            controller: controllerName,
                            //style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              //hintText: "Name",
                              //hintStyle: TextStyle(color: Colors.white70),
                              border: InputBorder.none,
                              errorText: invalidName
                                  ? 'Value Can\'t Be Empty'
                                  : null,
                            )),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        UIHelper.verticalSpaceMedium,
                        Text(
                          "Registration Number",
                          style: BoldStyle,
                        ),
                        TextField(
                            onTap: () {
                              setState(() {
                                invalidName = false;
                                invalidNumber = false;
                              });
                            },
                            controller: controllerNumber,
                            //style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              //hintText: "Name",
                              //hintStyle: TextStyle(color: Colors.white70),
                              border: InputBorder.none,
                              errorText: invalidNumber
                                  ? 'Value Can\'t Be Empty'
                                  : null,
                            )),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        UIHelper.verticalSpaceLarge,
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                MyButtonFull(
                  caption: "SAVE",
                  onPressed: () => {},
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DropdownExample extends StatefulWidget {
  @override
  _DropdownExampleState createState() {
    return _DropdownExampleState();
  }
}

class _DropdownExampleState extends State<DropdownExample> {
  String _value;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<String>(
        items: [
          DropdownMenuItem<String>(
            child: Text('Item 1'),
            value: 'one',
          ),
          DropdownMenuItem<String>(
            child: Text('Item 2'),
            value: 'two',
          ),
          DropdownMenuItem<String>(
            child: Text('Item 3'),
            value: 'three',
          ),
        ],
        onChanged: (String value) {
          setState(() {
            _value = value;
          });
        },
        hint: Text('Select Item'),
        value: _value,
      ),
    );
  }
}
