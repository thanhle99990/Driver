
import 'package:provider_arc/core/constants/enum.dart';

class AppStateModel {
  int _counter = 0;

  DriverStatus status;

  getStatus() => status;

  setStatus(DriverStatus _status) => status = _status;

  getCounter() => _counter;

  setCounter(int counter) => _counter = counter;

  void incrementCounter() {
    _counter++;
  }

  void decrementCounter() {
    _counter--;
  }
}