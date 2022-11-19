//
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider_arc/core/constants/app_contstants.dart';
import 'package:provider_arc/core/constants/enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static Future<int> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userid = prefs.getInt(KEYS.iddriver);
    return userid;
  }

  static Future<String> getEndpoint() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String endpoint = prefs.getString(KEYS.endpoint);
    return endpoint;
  }

  static void logIt(String log) {
    print(log);
  }
  static void logItdata(String log, dynamic data) {
    print(log + " : $data");
  }
  static Future<String> getDriverStatusString(DriverStatus driverStatus) async{
    String _driverStatusAsText='';
   /* switch (driverStatus) {
      case DriverStatus.booked:
        _driverStatusAsText = "Please wait..";
        break;
      case DriverStatus.completed:
        _driverStatusAsText = "Driver completed";
        break;
      case DriverStatus.cancel:
        _driverStatusAsText = "Driver cancel";
        break;

    }*/
    return _driverStatusAsText;
  }

  // !DECODE POLY
  static List decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
    // repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negative then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    /*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  static List<LatLng> convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))
        .buffer
        .asUint8List();
  }
}

/// Helper class for device related operations.
///
class DeviceUtils {
  static hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static double getScaledSize(BuildContext context, double scale) =>
      scale *
      (MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.height);

  static double getScaledWidth(BuildContext context, double scale) =>
      scale * MediaQuery.of(context).size.width;

  static double getScaledHeight(BuildContext context, double scale) =>
      scale * MediaQuery.of(context).size.height;
}
