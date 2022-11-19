import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider_arc/core/constants/app_contstants.dart';
import 'package:provider_arc/core/constants/enum.dart';
import 'package:provider_arc/core/models/car.dart';
import 'package:provider_arc/core/models/distanttime.dart';
import 'package:provider_arc/core/models/doc.dart';
import 'package:provider_arc/core/models/fcm.dart';
import 'package:provider_arc/core/models/his.dart';
import 'package:provider_arc/core/models/notification.dart';
import 'package:provider_arc/core/models/rating.dart';
import 'package:provider_arc/core/models/reason.dart';
import 'package:provider_arc/core/models/report/earning.dart';
import 'package:provider_arc/core/models/response.dart';
import 'package:provider_arc/core/models/ride.dart';
import 'package:provider_arc/core/models/setting.dart';
import 'package:provider_arc/core/models/userobj.dart';
import 'package:provider_arc/core/models/vehicletype.dart';
import 'package:provider_arc/core/models/version.dart';
import 'package:provider_arc/core/utils/device_utils.dart';
import 'package:provider_arc/core/utils/pref_helper.dart';

class Api {
  var endpoint = "";
  var client = new http.Client();
  var sharedPreferenceHelper = SharedPreferenceHelper();

  Future<VersionObj> getVersion() async {
    var _url = await sharedPreferenceHelper.endpoint + "/api/app/dversion";
    final response = await makeRequest(_url);
    VersionObj versionObj;
    if (response.statusCode == 200) {
      final Map parsed = json.decode(response.body);
      ResponseObj responseObj = ResponseObj.fromJson(parsed);
      versionObj = VersionObj.fromJson(responseObj.data);
    } else {
      throw Exception('Failed to load data');
    }
    return versionObj;
  }

  //=========================================================================================== <USER>
  static const USER = "";

  Future<ResponseObj> login(String email, String password) async {
    Map data = {'email': email, 'password': password};
    var body = json.encode(data);
    var _url = await sharedPreferenceHelper.endpoint + "/api/driver/loginemail";
    http.Response response = await makePost(_url, body);
    return ResponseObj.fromJson(json.decode(response.body));
  }

  Future<ResponseObj> loginPhone(String phone) async {
    Map data = {'phone': phone};
    var body = json.encode(data);
    var _url = await sharedPreferenceHelper.endpoint + "/api/driver/loginphone";
    http.Response response = await makePost(_url, body);
    return ResponseObj.fromJson(json.decode(response.body));
  }

  Future<ResponseObj> resetPassword(String email) async {
    Map data = {
      'email': email,
    };
    var body = json.encode(data);
    var _url = KEYS.endpoint + "/api/driver/resetpass";
    http.Response response = await makePost(_url, body);
    return ResponseObj.fromJson(json.decode(response.body));
  }

  Future<ResponseObj> getUserDetail() async {
    int userId = await sharedPreferenceHelper.userId;
    var _url = await sharedPreferenceHelper.endpoint + "/api/driver/detail/$userId";
    final response = await makeRequest(_url);
    print('nhan dc: ${response.body}');
    return ResponseObj.fromJson(json.decode(response.body));
  }

  Future<ResponseObj> signup(UserObj userObj) async {
    var body = json.encode(userObj);
    var _url = await sharedPreferenceHelper.endpoint + "/api/driver/signup";
    http.Response response = await makePost(_url, body);
    return ResponseObj.fromJson(json.decode(response.body));
  }

  Future<ResponseObj> changePassword(String password) async {
    int userId = await sharedPreferenceHelper.userId;
    Map data = {
      'iddriver': userId,
      'password': password,
    };
    var body = json.encode(data);
    var _url = await sharedPreferenceHelper.endpoint + "/api/driver";
    http.Response response = await makePut(_url, body);
    return ResponseObj.fromJson(json.decode(response.body));
  }

  Future<ResponseObj> updateProfile(UserObj userObj) async {
    int userId = await sharedPreferenceHelper.userId;
    userObj.iddriver =userId;
    var body = json.encode(userObj);
    var _url = await sharedPreferenceHelper.endpoint + "/api/driver";
    http.Response response = await makePut(_url, body);
    return ResponseObj.fromJson(json.decode(response.body));
  }

  Future<String> uploadProfile(String base64) async {
    int userId = await sharedPreferenceHelper.userId;
    var data = {"userid": userId.toString(), "image": base64};
    var _url =
        await sharedPreferenceHelper.endpoint + "/api/driver/profile/$userId";
    return http
        .post(_url,
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: data)
        .then((http.Response response) {
      print("response:" + response.body);
      return response.body;
    });
  }

  Future<String> uploadDocument(int type, String base64) async {
    int iddriver = await Utils.getUserId();
    var data = {
      "iddriver": iddriver.toString(),
      "type": type.toString(),
      "base64": base64
    };
    var _url = await sharedPreferenceHelper.endpoint + "/api/doc/upload";
    return http
        .post(_url,
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: data)
        .then((http.Response response) {
      print("response:" + response.body);
      return response.body;
    });
  }

  Future<List<NotifyObj>> getNotify(int userId) async {
    var _url =
        await sharedPreferenceHelper.endpoint + "/api/noti/driver/$userId";
    final response = await makeRequest(_url);
    List<NotifyObj> _list = List();
    if (response.statusCode == 200) {
      ResponseObj responseObj =
          ResponseObj.fromJson(json.decode(response.body));
      _list = (responseObj.data as List)
          .map((data) => new NotifyObj.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load data');
    }
    return _list;
  }

  Future<List<ReasonObj>> getReason() async {
    var _url =
        await sharedPreferenceHelper.endpoint + "/api/reason";
    final response = await makeRequest(_url);
    List<ReasonObj> _list = List();
    if (response.statusCode == 200) {
      ResponseObj responseObj =
      ResponseObj.fromJson(json.decode(response.body));
      _list = (responseObj.data as List)
          .map((data) => new ReasonObj.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load data');
    }
    return _list;
  }

  Future<List<VehicletypeObj>> getVehicle() async {
    var _url = await sharedPreferenceHelper.endpoint + "/api/vehicle";
    final response = await makeRequest(_url);
    List<VehicletypeObj> _list = List();
    if (response.statusCode == 200) {
      ResponseObj responseObj =
          ResponseObj.fromJson(json.decode(response.body));
      _list = (responseObj.data as List)
          .map((data) => new VehicletypeObj.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load data');
    }
    return _list;
  }

  Future<ResponseObj> addcar(CarObj carObj) async {
    int userId = await Utils.getUserId();
    carObj.iddriver = userId;
    var body = json.encode(carObj.toJson());
    var _url = await sharedPreferenceHelper.endpoint + "/api/car";
    http.Response response = await makePost(_url, body);
    return ResponseObj.fromJson(json.decode(response.body));
  }

  Future<CarObj> getCar() async {
    int iddriver = await Utils.getUserId();
    var _url =
        await sharedPreferenceHelper.endpoint + "/api/car/driver/$iddriver";
    final response = await makeRequest(_url);
    CarObj carObj;
    if (response.statusCode == 200) {
      final Map parsed = json.decode(response.body);
      ResponseObj responseObj = ResponseObj.fromJson(parsed);
      carObj = CarObj.fromJson(responseObj.data);
    } else {
      throw Exception('Failed to load data');
    }
    return carObj;
  }

  Future<DocObj> getDoc(int type) async {
    int iddriver = await Utils.getUserId();
    var _url =
        await sharedPreferenceHelper.endpoint + "/api/doc/$type/$iddriver";
    final response = await makeRequest(_url);
    DocObj obj;
    if (response.statusCode == 200) {
      final Map parsed = json.decode(response.body);
      ResponseObj responseObj = ResponseObj.fromJson(parsed);
      obj = DocObj.fromJson(responseObj.data);
    } else {
      throw Exception('Failed to load data');
    }
    return obj;
  }

  Future<ResponseObj> addRating(RatingObj obj) async {
    var body = json.encode(obj.toJson());
    var _url = await sharedPreferenceHelper.endpoint + "/api/rating";
    http.Response response = await makePost(_url, body);
    return ResponseObj.fromJson(json.decode(response.body));
  }

  //=========================================================================================== <CUSTOMER>
  static const CUSTOMER = "";

  Future<ResponseObj> getCustomerDetail(int idcustomer) async {
    var _url =
        await sharedPreferenceHelper.endpoint + "/api/customer/detail/$idcustomer";
    final response = await makeRequest(_url);
    print('nhan dc: ${response.body}');
    return ResponseObj.fromJson(json.decode(response.body));
  }

  Future<SettingObj> getSetting() async {
    var _url = await sharedPreferenceHelper.endpoint + "/api/setting";
    final response = await makeRequest(_url);
    SettingObj settingObj;
    if (response.statusCode == 200) {
      final Map parsed = json.decode(response.body);
      ResponseObj responseObj = ResponseObj.fromJson(parsed);
      settingObj = SettingObj.fromJson(responseObj.data);
    } else {
      throw Exception('Failed to load data');
    }
    return settingObj;
  }

  //=========================================================================================== <REPORT>
  static const REPORT = "";

  Future<double> getSumEarning() async {
    int userId = await Utils.getUserId();
    var _url = await sharedPreferenceHelper.endpoint +
        "/api/driver/report/sum/earning/" +
        userId.toString();
    final response = await makeRequest(_url);
    double revenue = 0;
    if (response.statusCode == 200) {
      final Map parsed = json.decode(response.body);
      revenue = parsed['data']['value'].toDouble();
      print('rating' + revenue.toString());
    } else {
      throw Exception('Failed to load data');
    }
    return revenue;
  }

  Future<double> getSumRating() async {
    int userId = await Utils.getUserId();
   /* var _url = await sharedPreferenceHelper.endpoint +
        "/api/driver/report/sum/rating/" +
        userId.toString();*/
    var _url = await sharedPreferenceHelper.endpoint +
        "/api/rating/driver/" +
        userId.toString();
    final response = await makeRequest(_url);
    double revenue = 0;
    if (response.statusCode == 200) {
      final Map parsed = json.decode(response.body);
      revenue = parsed['data']['value'].toDouble();
      print('rating' + revenue.toString());
    } else {
      throw Exception('Failed to load data');
    }
    return revenue;
  }

  Future<int> getNumRide() async {
    int userId = await Utils.getUserId();
    var _url = await sharedPreferenceHelper.endpoint +
        "/api/driver/report/sum/numride/" +
        userId.toString();
    final response = await makeRequest(_url);
    int revenue = 0;
    if (response.statusCode == 200) {
      final Map parsed = json.decode(response.body);
      revenue = parsed['data']['value'];
      print('rating' + revenue.toString());
    } else {
      throw Exception('Failed to load data');
    }
    return revenue;
  }

  Future<List<EarningRpt>> getEarning() async {
    var userid = await sharedPreferenceHelper.userId;
    var _url = await sharedPreferenceHelper.endpoint +
        "/api/report/earning/driver/$userid";
    final response = await makeRequest(_url);
    List<EarningRpt> _list = List();
    if (response.statusCode == 200) {
      ResponseObj responseObj =
          ResponseObj.fromJson(json.decode(response.body));
      _list = (responseObj.data as List)
          .map((data) => new EarningRpt.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load data');
    }
    return _list;
  }

  Future<DistanttimeObj> getDistantTime(LatLng latLng1, LatLng latLng2) async {
    String url =
        "https://maps.googleapis.com/maps/api/distancematrix/json?key=" +
            KEYS.keyMap +
            "&origins=" +
            latLng1.latitude.toString() +
            "," +
            latLng1.longitude.toString() +
            "&destinations=" +
            latLng2.latitude.toString() +
            "," +
            latLng2.longitude.toString();
    print("gg_distanttime >>: " + url);
    var res = await http.get(url);
    print("res " + json.decode(res.body).toString());
    if (res.statusCode == 200) {
      DistanttimeObj distanttimeObj =
      DistanttimeObj.fromJson(json.decode(res.body));
      return distanttimeObj;
    } else {
      return null;
    }
  }
//=========================================================================================== <TRIP>
  static const TRIP = "";

  Future<List<HisObj>> getHistory() async {
    var userid = await sharedPreferenceHelper.userId;
    var _url =
        await sharedPreferenceHelper.endpoint + "/api/ride/driver/$userid";
    final response = await makeRequest(_url);
    List<HisObj> _list = List();
    if (response.statusCode == 200) {
      ResponseObj responseObj =
          ResponseObj.fromJson(json.decode(response.body));
      _list = (responseObj.data as List)
          .map((data) => new HisObj.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load data');
    }
    return _list;
  }

  Future<ResponseObj> getRide(int idride) async {
    var _url =
        await sharedPreferenceHelper.endpoint + "/api/ride/detail/$idride";
    final response = await makeRequest(_url);
    ResponseObj responseObj;
    if (response.statusCode == 200) {
      responseObj = ResponseObj.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
    return responseObj;
  }

  Future<ResponseObj> updateRide(RideObj rideObj, DriverStatus driverStatus) async {
    String status = EnumToString.parse(driverStatus);
    rideObj.status = status;
    var body = json.encode(rideObj.toJson());
    var _url = await sharedPreferenceHelper.endpoint + "/api/ride";
    http.Response response = await makePost(_url, body);
    return ResponseObj.fromJson(json.decode(response.body));
  }

  //=========================================================================================== <BASIC>
  static const BASIC = "";

  Future<void> sendFcm(String token, String message) async {
    Map data = {'registrationToken': token, "message": message};
    var body = json.encode(data);
    var _url = await sharedPreferenceHelper.endpoint + "/api/noti/send";
    http.Response response = await makePost(_url, body);
    print(response);
  }


  Future<http.Response> makeRequest(String url) async {
    print("calling -> " + url);
    return await http.get(url);
  }

  Future<http.Response> makePost(String url, body) async {
    print("calling -> " + url);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
    print('response: ' + response.body);
    return response;
  }

  Future<http.Response> makePut(String url, body) async {
    print("calling -> " + url);
    var response = await http.put(url,
        headers: {"Content-Type": "application/json"}, body: body);
    print('response: ' + response.body);
    return response;
  }
}
