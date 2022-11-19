import 'dart:async';

import 'package:provider_arc/core/constants/enum.dart';
import 'package:provider_arc/core/models/appstate.dart';

class AppStateService {

  StreamController<AppStateModel> _userController = StreamController<AppStateModel>();

  Stream<AppStateModel> get appstate => _userController.stream;

  setState(DriverStatus state) async {
    AppStateModel appStateModel = AppStateModel();
    appStateModel.setStatus(state);
    _userController.add(appStateModel);
  }

}
