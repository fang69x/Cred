import 'package:flutter/foundation.dart';
import 'package:cred/data/models/api.model.dart';
import 'package:cred/data/service/api_service.dart';

class CredDataProvider extends ChangeNotifier {
  CredModel? _credData;
  bool _isLoading = false;
  String? _error;

  CredModel? get credData => _credData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  CredDataProvider() {
    fetchData();
  }

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();
    try {
      _credData = await Apiservice.fetchData();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
