import 'package:flutter/material.dart';
import 'package:refuelings_collector/models/refueling.dart';
import 'package:refuelings_collector/services/api_requester.dart';

class CurrentRefueling extends ChangeNotifier {
  double _averageFuel;
  bool _isLoading = false;

  double get averageFuel => _averageFuel;
  bool get isLoading => _isLoading;

  void refreshAverageFuel(double liters, double kilometers) {
    if (kilometers == 0)
      _averageFuel = 0.00;
    else
      _averageFuel = liters / kilometers * 100;
    notifyListeners();
  }

  void resetAverageFuel() => _averageFuel = null;

  Future<String> saveEntry(Refueling refueling) async {
    _isLoading = true;
    notifyListeners();

    String _message;

    if (refueling.id == null) {
      _message = await ApiRequester().createRefueling(refueling);
    } else {
      _message = await ApiRequester().updateRefueling(refueling);
    }

    _isLoading = false;
    notifyListeners();

    return _message;
  }

  Future<String> deleteEntry(Refueling refueling) async {
    _isLoading = true;
    notifyListeners();

    String _message;

    _message = await ApiRequester().deleteRefueling(refueling);

    _isLoading = false;
    notifyListeners();

    return _message;
  }
}
