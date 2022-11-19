import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:provider_arc/core/models/car.dart';
import 'package:provider_arc/core/models/response.dart';
import 'package:provider_arc/core/models/setting.dart';
import 'package:provider_arc/core/models/vehicletype.dart';
import 'package:provider_arc/core/services/api.dart';
import 'package:provider_arc/ui/shared/app_colors.dart';
import 'package:provider_arc/ui/shared/ui_helpers.dart';
import 'package:provider_arc/ui/widgets/custom/mybutton.dart';
import 'package:provider_arc/ui/widgets/custom/mydialog.dart';
import 'package:provider_arc/ui/widgets/custom/mytitle.dart';
import 'package:provider_arc/ui/widgets/dummy.dart';
import 'package:provider_arc/ui/widgets/loading.dart';

class CarView extends KFDrawerContent {
  @override
  _AddCarState createState() => _AddCarState();
}

class _AddCarState extends State<CarView> {
  final TextEditingController controllerModel = new TextEditingController();
  final TextEditingController controllerColor = new TextEditingController();
  final TextEditingController controllerPlate = new TextEditingController();
  final TextEditingController controllerSeat = new TextEditingController();

  int _mySelection;

  List<VehicletypeObj> _list = List();
  Api api = Api();
  bool loading = true;
  CarObj _car = CarObj();
  SettingObj settingObj;

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  void getData() async {
    List<VehicletypeObj> list = await api.getVehicle();
    CarObj obj = await api.getCar();
    settingObj = await api.getSetting();
    setState(() {
      settingObj;
      _list = list;
      _car = obj;
      _mySelection = _car.type;
      controllerModel.text = _car.model;
      controllerColor.text = _car.color;
      controllerPlate.text = _car.plate;
      controllerSeat.text = _car.seat.toString();
      loading = false;
    });

    print(_list.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text("Vehicle"),
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: widget.onMenuPressed,
          ),
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
                      text: "Vehicle",
                    ),
                    UIHelper.verticalSpaceMedium,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyH2(text: "Vehicle type"),
                        settingObj.editvehicle == 0
                            ? Text(_car.typename)
                            : Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: DropdownButton(
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
                    settingObj.editvehicle == 0
                        ? Dummy()
                        : MyButton(
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
    carObj.idcar = _car.idcar;

    ResponseObj responseObj = await api.addcar(carObj);
    var success = responseObj.code == 0;
    if (success) {
      DialogUtils.showSimpleDialog(
        context,
        title: "Save successful",
      );
    } else {
      DialogUtils.showSimpleDialog(
        context,
        title: responseObj.message,
      );
    }
  }
}
