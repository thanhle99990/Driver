import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart' as poly;
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';

//import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as location;
import 'package:provider_arc/core/constants/app_contstants.dart';
import 'package:provider_arc/core/constants/enum.dart';
import 'package:provider_arc/core/models/customer.dart';
import 'package:provider_arc/core/models/distanttime.dart';
import 'package:provider_arc/core/models/rating.dart';
import 'package:provider_arc/core/models/reason.dart';
import 'package:provider_arc/core/models/response.dart';
import 'package:provider_arc/core/models/ride.dart';
import 'package:provider_arc/core/models/tbao.dart';
import 'package:provider_arc/core/models/userobj.dart';
import 'package:provider_arc/core/services/api.dart';
import 'package:provider_arc/core/utils/device_utils.dart';
import 'package:provider_arc/core/utils/log.dart';
import 'package:provider_arc/core/utils/pref_helper.dart';
import 'package:provider_arc/ui/shared/app_colors.dart';
import 'package:provider_arc/ui/views/chat/models/user_details.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  print("onBackgroundMessage: $message");
  return Future<void>.value();
}

class MapViewModel extends ChangeNotifier {
  final mapScreenScaffoldKey = GlobalKey<ScaffoldState>();
  Api api = Api();
  SocketIO _socketIO;
  SharedPreferenceHelper _sharedPreferenceHelper = SharedPreferenceHelper();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //Ride
  RideObj _rideObj = RideObj();
  DriverStatus _driverStatus = DriverStatus.none;
  UserObj _userObj;

  //sum
  double earning;
  double rating;
  double acceptance;
  int numRide;

  List<ReasonObj> listReason = [];

  LatLng _currentPosition;
  Customer _currCustomer;
  DistanttimeObj kmTimeToCustomer;

  TbaoObj _tbaoObj = TbaoObj(isshow: false, noidung: "");

  double currentZoom = 14;

  final Set<Marker> _markers = Set();

  final Set<Polyline> _polyLines = Set();

  List<Prediction> pickupPredictions = [];

  List<Prediction> destinationPredictions = [];

  GoogleMapController _mapController;

  TextEditingController pickupFormFieldController = TextEditingController();

  TextEditingController destinationFormFieldController =
      TextEditingController();

  RideObj get rideObj => _rideObj;

  UserObj get userObj => _userObj;

  location.Location _location = location.Location();

  Customer get currCustomer => _currCustomer;

  //RequestObj get requestObj => _requestObj;

  DriverStatus get driverStatus => _driverStatus;

  TbaoObj get tbaoObj => _tbaoObj;

  // currentPosition Getter
  LatLng get currentPosition => _currentPosition;

  // currentPosition Getter
  //LatLng get destinationPosition => _destinationPosition;

  // currentPosition Getter
  //LatLng get pickupPosition => _pickupPosition;

  // MapController Getter
  GoogleMapController get mapController => _mapController;

  // Markers Getter
  Set<Marker> get markers => _markers;

  // PolyLines Getter
  Set<Polyline> get polyLines => _polyLines;

  get randomZoom => 13.0 + Random().nextInt(4);
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  void init() {
    initFcm();
    getInitData();
    getUserData();
    getSumData();
    getLocation();
    initSocketio();
  }

  /// when map is created
  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _location.changeSettings(interval: 20000);
    _location.onLocationChanged().listen((event) async {
      try {
        _currentPosition = LatLng(event.latitude, event.longitude);
        removeMarker(Constants.currentLocationMarkerId);

        UserObj newUser = UserObj();
        newUser.latitude = _currentPosition.latitude;
        newUser.longitude = _currentPosition.longitude;
        newUser.online = userObj.online;
        api.updateProfile(newUser);

        Marker marker = Marker(
            markerId: MarkerId(Constants.currentLocationMarkerId),
            position: _currentPosition,
            draggable: true,
            rotation: event.heading - 78,
            flat: true,
            anchor: Offset(0.5, 0.5),
            icon: BitmapDescriptor.fromBytes(await Utils.getBytesFromAsset(
                "assets/icons/iconcar.png", 200)));
        _markers.add(marker);
        /*AnimateMarker(onMarkerPosUpdate: (Marker marker) {})
            .animaterMarker(marker.position, _currentPosition, marker);*/

        CameraPosition cPosition = CameraPosition(
          zoom: currentZoom,
          //tilt: CAMERA_TILT,
          //bearing: CAMERA_BEARING,
          target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
        );
        if (_driverStatus == DriverStatus.gotopickup ||
            _driverStatus == DriverStatus.arrived) {
          _mapController
              .animateCamera(CameraUpdate.newCameraPosition(cPosition));
        }

        if (_driverStatus == DriverStatus.gotopickup ||
            _driverStatus == DriverStatus.beginride ||
            _driverStatus == DriverStatus.arrived) {
          LatLng obj =
              LatLng(_currentPosition.latitude, _currentPosition.longitude);
          sendMessage('location', _currCustomer.idcustomer, null,
              "{\"lat\": ${_currentPosition.latitude},\"lng\": ${_currentPosition.longitude},\"heading\": ${event.heading}}");
        }
      } on Exception catch (_) {
        //print('error on update location');
      }
      notifyListeners();
    });
    notifyListeners();
  }

  Future<void> getInitData() async {
    listReason = await api.getReason();
    notifyListeners();
  }

  Future<void> getUserData() async {
    ResponseObj responseObj = await api.getUserDetail();
    if (responseObj.code == 0) {
      _userObj = UserObj.fromJson(responseObj.data);
      addDataToDb(_userObj);
      print('idride ${_userObj.idride}');
      if (_userObj.idride != 0) {
        ResponseObj responseObj1 = await api.getRide(_userObj.idride);
        if (responseObj1.code == 0) {
          _rideObj = RideObj.fromJson(responseObj1.data);
        }
        DriverStatus driverStatus =
            EnumToString.fromString(DriverStatus.values, rideObj.status);
        if (driverStatus == DriverStatus.cancel) {
          UserObj newUser = UserObj();
          newUser.idride = 0;
          await api.updateProfile(newUser);
        } else {
          ResponseObj responseObj =
              await api.getCustomerDetail(_rideObj.idcustomer);
          if (responseObj.code == 0) {
            _currCustomer = Customer.fromJson(responseObj.data);
          }
        }
        setStatus(driverStatus);
      }
      if (_userObj.active == 0) {
        _tbaoObj.isshow = true;
        _tbaoObj.noidung = 'Your account need to verify, please wait...';
      } else {
        _tbaoObj.isshow = false;
      }
    }
    notifyListeners();
  }

  Future<void> getSumData() async {
    earning = await api.getSumEarning();
    //rating = await api.getSumRating();

    //acceptance = await api.getSumAccept();
    numRide = await api.getNumRide();
    notifyListeners();
  }

  ///Getting current Location : Works only one time
  void getLocation() async {
    _markers.clear();
    _location.getLocation().then((data) async {
      _currentPosition = LatLng(data.latitude, data.longitude);
      UserObj newUser = UserObj();
      newUser.latitude = _currentPosition.latitude;
      newUser.longitude = _currentPosition.longitude;
      api.updateProfile(newUser);
      addMarker(
          _currentPosition, Constants.currentLocationMarkerId, CMarker.driver);

      notifyListeners();
    });
  }

  void createRoute(LatLng point1, LatLng point2) async {
    List<LatLng> list = List();
    poly.PolylinePoints polylinePoints = poly.PolylinePoints();
    poly.PointLatLng from = poly.PointLatLng(point1.latitude, point1.longitude);
    poly.PointLatLng to = poly.PointLatLng(point2.latitude, point2.longitude);

    poly.PolylineResult result = await polylinePoints
        .getRouteBetweenCoordinates(KEYS.keyDirectionMap, from, to,
            travelMode: poly.TravelMode.transit);
    if (result.points.isNotEmpty) {
      result.points.forEach((poly.PointLatLng point) {
        list.add(LatLng(point.latitude, point.longitude));
      });
    }
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        patterns: <PatternItem>[],
        color: PrimaryColor,
        points: list,
        width: 3,
        onTap: () {});
    _polyLines.add(polyline);
    notifyListeners();
  }

  /// listening to camera moving event
  void onCameraMove(CameraPosition position) {
    ////ProjectLog.logIt(TAG, "onCameraMove", position.target.toString());
    currentZoom = position.zoom;
    notifyListeners();
  }

  void randomMapZoom() {
    mapController
        .animateCamera(CameraUpdate.zoomTo(15.0 + Random().nextInt(5)));
  }

  void onMyLocationFabClicked() {
    mapController.animateCamera(CameraUpdate.newLatLngZoom(
        currentPosition, 15.0 + Random().nextInt(4)));
  }

  void onIconMapClicked(Customer customer) {
    LatLng latLng = LatLng(customer.latitude, customer.longitude);
    mapController.animateCamera(
        CameraUpdate.newLatLngZoom(latLng, 15.0 + Random().nextInt(4)));
  }

  Future<void> addMarker(LatLng location, String id, CMarker cMarker) async {
    String icon;
    int size = 200;
    switch (cMarker) {
      case CMarker.pick:
        icon = "assets/icons/icopass.png";
        //size = 100;
        break;
      case CMarker.destination:
        icon = "assets/icons/dest.png";
        break;
      case CMarker.driver:
        icon = "assets/icons/iconcar.png";
        break;
    }
    if (location == null) return;
    _markers.add(Marker(
        markerId: MarkerId(id),
        position: location,
        draggable: true,
        //rotation: event.heading - 78,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(
            await Utils.getBytesFromAsset(icon, size))));
    notifyListeners();
  }

  void removeMarker(String myId) {
    _markers.removeWhere((m) => m.markerId.value == myId);
    notifyListeners();
  }

  //=================================================================================== <DOING>
  static const String DOING = "";

  void setStatus(DriverStatus value) {
    _driverStatus = value;
    notifyListeners();
  }

  Future<void> accept() async {
    api.updateRide(_rideObj, DriverStatus.gotopickup);
    _driverStatus = DriverStatus.gotopickup;
    sendMessage('accept', _currCustomer.idcustomer, null, null);
    sendFcm(_currCustomer.token, "Driver accept your request");
    LatLng point = LatLng(_currCustomer.latitude, _currCustomer.longitude);
    kmTimeToCustomer = await api.getDistantTime(_currentPosition, point);
    notifyListeners();
  }

  Future<void> cancelRide(int idreason) async {
    sendMessage('cancel', _currCustomer.idcustomer, _rideObj.idride, null);
    sendFcm(_currCustomer.token, "Driver cancel your request");
    await api.updateRide(_rideObj, DriverStatus.cancel);
    backNone();
  }

  Future<void> reject() async {
    await api.updateRide(_rideObj, DriverStatus.cancel);
    delay(numberOfSeconds: 3);
    sendMessage('reject', _currCustomer.idcustomer, null, null);
    sendFcm(_currCustomer.token, "Driver reject your request");

    backNone();
    notifyListeners();
  }

  void cancelConfirm() {
    _driverStatus = DriverStatus.cancel;
    notifyListeners();
  }

  void cancelNo() {
    _driverStatus = DriverStatus.arrived;
    notifyListeners();
  }

  void complete() {
    api.updateRide(_rideObj, DriverStatus.complete);
    _driverStatus = DriverStatus.rating;
    sendMessage("complete", _currCustomer.idcustomer, null, null);
    sendFcm(_currCustomer.token, "Your trip has complete");
    notifyListeners();
  }

  void arrived() {
    _driverStatus = DriverStatus.arrived;
    sendMessage("arrived", _currCustomer.idcustomer, null, null);
    sendFcm(_currCustomer.token, "Driver has arrived");
    notifyListeners();
  }

  void beginRide() {
    _polyLines.clear();
    removeMarker(Constants.pickupMarkerId);
    LatLng driver =
        LatLng(_currentPosition.latitude, _currentPosition.longitude);
    LatLng des = LatLng(_rideObj.tolat, _rideObj.tolng);
    addMarker(des, Constants.destinationMarkerId, CMarker.destination);
    createRoute(driver, des);

    _driverStatus = DriverStatus.beginride;
    sendMessage("beginride", _currCustomer.idcustomer, null, null);
    sendFcm(_currCustomer.token, "Ride is start");
    notifyListeners();
  }

  void submitRating(RatingObj obj) {
    api.addRating(obj);
    backNone();
    notifyListeners();
  }

//#5
  void backNone() async {
    delay(numberOfSeconds: 3);
    getSumData();
    getUserData();
    _polyLines.clear();
    removeMarker(Constants.pickupMarkerId);
    removeMarker(Constants.destinationMarkerId);
    _driverStatus = DriverStatus.none;
    getLocation();
  }

  void updateOnline(int online) async {
    UserObj newUser = UserObj();
    newUser.online = online;
    newUser.idride = 0;
    api.updateProfile(newUser);
    if (online == 1) {
      sendMessageAll('online');
    } else {
      sendMessageAll('offline');
    }
    getSumData();
  }

  void hideNote() async {
    _tbaoObj.isshow = false;
    notifyListeners();
  }

  void showNote() async {
    _tbaoObj.isshow = true;
    notifyListeners();
  }

  void verify() async {
    UserObj newUser = UserObj();
    newUser.active = 1;
    await api.updateProfile(newUser);
    getUserData();
  }

  //=================================================================================== <COMUNICATE>
  static const String COMUNICATE = "";

  void sendFcm(String token, String message) {
    api.sendFcm(token, message);
  }

  initSocketio() async {
    int chatID = await _sharedPreferenceHelper.userId;
    try {
      SocketIOManager().destroyAllSocket();
    } on Exception catch (_) {
      print("throwing new error");
      throw Exception("Error on server");
    }
    _socketIO = SocketIOManager()
        .createSocketIO(KEYS.socketIo, '/', query: 'chatID=$chatID');
    _socketIO.init();
    _socketIO.subscribe('receive_message', (jsonData) {
      //print("jsonData:" + json.encode(jsonData));
      messageOn(jsonData);
    });
    _socketIO.subscribe('receive_all', (jsonData) {
      //print("jsonData:" + json.encode(jsonData));
      messageOnAll(jsonData);
    });
    _socketIO.connect();
  }

  void sendMessage(
      String content, int receiverChatID, int value, String text) async {
    int chatID = await _sharedPreferenceHelper.userId;
    _socketIO.sendMessage(
      'send_message',
      json.encode({
        'receiverChatID': receiverChatID.toString(),
        'senderChatID': chatID,
        'content': content,
        'value': value,
        'text': text,
      }),
    );
  }

  void sendMessageAll(String text) async {
    int chatID = await _sharedPreferenceHelper.userId;
    _socketIO.sendMessage(
      'send_all',
      json.encode({
        'receiverChatID': 'all',
        'senderChatID': chatID,
        'content': text,
      }),
    );
  }

  void messageOn(String jsonData) {
    print("messageOn:" + json.encode(jsonData));
    Map<String, dynamic> data = json.decode(jsonData);
    String content = data['content'];
    int senderChatID = data['senderChatID'];
    int value = data['value'];
    String text = data['text'];
    processContent(senderChatID, content, value, text);
  }

  void messageOnAll(String jsonData) {
    print("messageOnAll:" + json.encode(jsonData));
    Map<String, dynamic> data = json.decode(jsonData);
    String content = data['content'];
    int senderChatID = data['senderChatID'];
    processContent(senderChatID, content, null, null);
  }

  Future<void> processContent(
      int senderChatID, String content, int value, String text) async {
    if (content == 'request') {
      request(senderChatID, value);
    } else if (content == 'cancel') {
      cancelByCustomer();
    }
  }

  void request(int idcustomer, int idride) async {
    ResponseObj responseObj = await api.getRide(idride);
    if (responseObj.code == 0) {
      _rideObj = RideObj.fromJson(responseObj.data);
    }
    ResponseObj responseObj2 = await api.getCustomerDetail(idcustomer);
    if (responseObj.code == 0) {
      _currCustomer = Customer.fromJson(responseObj2.data);
    }
    LatLng driver =
        LatLng(_currentPosition.latitude, _currentPosition.longitude);
    //addMarker(driver, Constants.currentLocationMarkerId, CMarker.driver);
    LatLng pickup = LatLng(_rideObj.fromlat, _rideObj.fromlng);
    addMarker(pickup, Constants.pickupMarkerId, CMarker.pick);

    createRoute(driver, pickup);

    _driverStatus = DriverStatus.request;
    notifyListeners();
  }

  void cancelByCustomer() async {
    await delay(numberOfSeconds: 3);
    backNone();
    notifyListeners();
  }

  initFcm() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    _firebaseMessaging.configure(
      // ignore: missing_return
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
        //displayNotification(message);
        _showNotificationWithSound(message);
      },
      // ignore: missing_return
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
        //displayNotification(message);
        _showNotificationWithSound(message);
      },
      // ignore: missing_return
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
        //displayNotification(message);
        _showNotificationWithSound(message);
      },
      //onBackgroundMessage: myBackgroundMessageHandler,
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print('token:' + token);
      UserObj newUser = UserObj();
      newUser.token = token;
      api.updateProfile(newUser);
    });
  }

  Future displayNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'channelid', 'flutterfcm', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      platformChannelSpecifics,
      payload: 'hello',
    );
  }

  Future _showNotificationWithSound(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        sound: RawResourceAndroidNotificationSound('sound'),
        importance: Importance.Max,
        priority: Priority.High);
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(sound: "sound.mp3");
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      platformChannelSpecifics,
      payload: 'Custom_Sound',
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  Future onDidRecieveLocalNotification(
      int id, String title, String body, String payload) async {}

  void addDataToDb(UserObj user) {
    DocumentReference _documentReference;
    UserDetails _userDetails = UserDetails();
    var mapData = Map<String, String>();
    String uid;
    _userDetails.name = user.name;
    _userDetails.emailId = user.email;
    _userDetails.photoUrl = user.profile;
    _userDetails.uid = user.iddriver.toString();
    _userDetails.phone = user.phone;
    _userDetails.token = user.phone;

    mapData = _userDetails.toMap(_userDetails);

    uid = user.iddriver.toString();

    _documentReference = Firestore.instance.collection("users").document(uid);

    _documentReference.get().then((documentSnapshot) {
      if (documentSnapshot.exists) {
        Log.info('exists user on firestore');
      } else {
        _documentReference.setData(mapData).whenComplete(() {
          Log.info("Users Colelction added to Database");
          /* Navigator.pushReplacement(context,
              new MaterialPageRoute(builder: (context) => AllUsersScreen()));*/
        }).catchError((e) {
          print("Error adding collection to Database $e");
        });
      }
    });
  }

  void findDistantDuration() async {
    LatLng _from = LatLng(_rideObj.fromlat, _rideObj.fromlng);
    LatLng _to = LatLng(_rideObj.tolat, _rideObj.tolng);
    if (_from == null) return;
    if (_to == null) return;
    DistanttimeObj distanttimeObj = await api.getDistantTime(_from, _to);
    print(json.encode(distanttimeObj));

    _rideObj.kmtext = distanttimeObj.rows[0].elements[0].distance.text;
    _rideObj.timetext = distanttimeObj.rows[0].elements[0].duration.text;

    _rideObj.km = distanttimeObj.rows[0].elements[0].distance.value;
    _rideObj.time = distanttimeObj.rows[0].elements[0].duration.value;

    //int km = distanttimeObj.rows[0].elements[0].distance.value;
    //_rideObj.price = (1 * km / 1000) + settingObj.initrace;

    notifyListeners();
  }

  void delay({@required int numberOfSeconds}) async {
    await Future.delayed(Duration(seconds: numberOfSeconds));
  }
}
