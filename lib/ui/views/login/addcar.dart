import 'package:flutter/material.dart';
import 'package:provider_arc/core/constants/app_contstants.dart';
import 'package:provider_arc/core/models/car.dart';
import 'package:provider_arc/core/models/response.dart';
import 'package:provider_arc/core/models/vehicletype.dart';
import 'package:provider_arc/core/services/api.dart';
import 'package:provider_arc/ui/shared/app_colors.dart';
import 'package:provider_arc/ui/shared/ui_helpers.dart';
import 'package:provider_arc/ui/widgets/custom/mybutton.dart';
import 'package:provider_arc/ui/widgets/custom/mydialog.dart';
import 'package:provider_arc/ui/widgets/custom/mytitle.dart';
import 'package:provider_arc/ui/widgets/loading.dart';

class AddCar extends StatefulWidget {
  @override
  _AddCarState createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {
  final TextEditingController controllerModel = new TextEditingController();
  final TextEditingController controllerColor = new TextEditingController();
  final TextEditingController controllerPlate = new TextEditingController();
  final TextEditingController controllerSeat = new TextEditingController();

  int _mySelection;

  List<VehicletypeObj> _list = List();
  Api api = Api();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  void getData() async {
    List<VehicletypeObj> list = await api.getVehicle();
    setState(() {
      _list = list;
      loading = false;
    });
    print(_list.length);
  }

  void save(BuildContext context) async {

    if (_mySelection == 0 || _mySelection == null) {
      DialogUtils.showToast("Please input vehicle type");
      return;
    }
    if (controllerModel.text.isEmpty) {
      DialogUtils.showToast("Please input model");
      return;
    }
    if (controllerPlate.text.isEmpty) {
      DialogUtils.showToast("Please input plate");
      return;
    }
    if (controllerSeat.text.isEmpty) {
      DialogUtils.showToast("Please input plate");
      return;
    }
    CarObj carObj = CarObj();
    carObj.type = _mySelection;
    carObj.model = controllerModel.text;
    carObj.plate = controllerPlate.text;
    carObj.color = controllerColor.text;
    carObj.seat = int.parse(controllerSeat.text);

    ResponseObj responseObj = await api.addcar(carObj);
    var success = responseObj.code == 0;
    if (success) {
      Navigator.pushNamed(context, RoutePaths.Adddoc);
    } else {
      DialogUtils.showSimpleDialog(
        context,
        title: responseObj.message,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text("Vehicle"),
          /*leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),*/
        ),
        body: loading
            ? Loading()
            : SingleChildScrollView(
                child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyH1(
                      text: "Add Vehicle",
                    ),
                    UIHelper.verticalSpaceMedium,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyH2(text: "Vehicle type"),
                        DropdownButton(
                          items: _list.map((item) {
                            return new DropdownMenuItem(
                              child: new Text(item.typename),
                              value: item.idvehicle,
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              _mySelection = newVal;
                            });
                          },
                          value: _mySelection,
                        ),
                      ],
                    ),
                    UIHelper.verticalSpaceMedium,
                    MyH2(text: "Model"),
                    UIHelper.verticalSpaceSmall,
                    TextField(
                      controller: controllerModel,
                      decoration: InputDecoration(
                          hintText: "Enter model",
                          hintStyle: TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: LightGrey, width: 5.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 16.0)),
                    ),
                    UIHelper.verticalSpaceSmall,
                    MyH2(text: "Plate"),
                    UIHelper.verticalSpaceSmall,
                    TextField(
                      controller: controllerPlate,
                      decoration: InputDecoration(
                          hintText: "Enter plate",
                          hintStyle: TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: LightGrey, width: 5.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 16.0)),
                    ),
                    UIHelper.verticalSpaceSmall,
                    MyH2(text: "Color"),
                    UIHelper.verticalSpaceSmall,
                    TextField(
                      controller: controllerColor,
                      decoration: InputDecoration(
                          hintText: "Enter color",
                          hintStyle: TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: LightGrey, width: 5.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 16.0)),
                    ),
                    UIHelper.verticalSpaceSmall,
                    MyH2(text: "Seat"),
                    UIHelper.verticalSpaceSmall,
                    TextField(
                      controller: controllerSeat,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "Enter seat",
                          hintStyle: TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: LightGrey, width: 5.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 16.0)),
                    ),
                    UIHelper.verticalSpaceMedium,
                    MyButton(
                      caption: "Save",
                      fullsize: true,
                      onPressed: () {
                        save(context);
                      },
                    ),
                  ],
                ),
              )));
  }
}
