import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:provider_arc/core/constants/enum.dart';
import 'package:provider_arc/core/services/api.dart';
import 'package:provider_arc/core/viewmodels/views/map_view_model.dart';
import 'package:provider_arc/ui/views/base_widget.dart';
import 'package:provider_arc/ui/views/home/state/beginride.dart';
import 'package:provider_arc/ui/views/home/state/cancel.dart';
import 'package:provider_arc/ui/views/home/state/none.dart';
import 'package:provider_arc/ui/views/home/state/rating.dart';
import 'package:provider_arc/ui/views/home/state/request.dart';
import 'package:provider_arc/ui/widgets/custom/mydialog.dart';
import 'package:provider_arc/ui/widgets/dummy.dart';
import 'package:provider_arc/ui/widgets/loading.dart';

import 'state/gopickup.dart';
import 'state/message.dart';

// ignore: must_be_immutable
class HomeView extends KFDrawerContent {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  //PanelController _pc = new PanelController();
  bool show = false;
  Api api = Api();


  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<MapViewModel>(
        model: MapViewModel(),
        onModelReady: (model) => model.init(),
        builder: (context, model, child) => WillPopScope(
            onWillPop: () => _onWillPop(model),
            child: Scaffold(
              body: SafeArea(
                child: Stack(
                  children: <Widget>[
                    model.currentPosition == null
                        ? Loading()
                        : GoogleMap(
                            initialCameraPosition: CameraPosition(
                                target: model.currentPosition,
                                zoom: model.currentZoom),
                            onMapCreated: model.onMapCreated,
                            mapType: MapType.normal,
                            rotateGesturesEnabled: false,
                            tiltGesturesEnabled: false,
                            zoomGesturesEnabled: true,
                            zoomControlsEnabled: false,
                            markers: model.markers,
                            onCameraMove: model.onCameraMove,
                            polylines: model.polyLines,
                          ),
                    model.driverStatus == DriverStatus.none || model.driverStatus == DriverStatus.cancel
                        ? None(
                            model: model,
                            onMenuPressed: widget.onMenuPressed,
                          )
                        : Dummy(),
                    model.driverStatus == DriverStatus.request ||
                        model.driverStatus == DriverStatus.booking
                        ? Request(
                            model: model,
                          )
                        : Dummy(),
                    model.driverStatus == DriverStatus.gotopickup||
                        model.driverStatus == DriverStatus.arrived
                        ? GoPickup(
                            model: model,
                          )
                        : Dummy(),
                    /*model.driverStatus == DriverStatus.cancel
                        ? Cancel(
                            model: model,
                          )
                        : Dummy(),*/
                    model.driverStatus == DriverStatus.beginride
                        ? BeginRide(
                            model: model,
                          )
                        : Dummy(),
                    model.driverStatus == DriverStatus.rating
                        ? Rating(
                            model: model,
                          )
                        : Dummy(),
                    model.tbaoObj.isshow
                        ? MessageState(
                            model: model,
                          )
                        : Dummy(),
                  ],
                ),
              ),
            )));
  }

  // ignore: missing_return
  Future<bool> _onWillPop(MapViewModel model) {
    if (model.driverStatus == DriverStatus.none) {
      DialogUtils.showCustomDialog(context, okBtnFunction: () {
        Navigator.of(context).pop(false);
      }, title: "Exit app?");
    }
    /* if (model.driverStatus == DriverStatus.book) {
      DialogUtils.showCustomDialog(context, okBtnFunction: () {
        model.cancelBooking();
        Navigator.of(context).pop(false);
      }, title: "Cancel booking?");
    }*/
  }




}
