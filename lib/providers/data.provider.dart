import 'package:cred/service/api.service.dart';
import 'package:flutter/foundation.dart';
import 'package:cred/models/api.model.dart';

class DataProvider with ChangeNotifier {
  CredModel? _apiResponse;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  CredModel? get apiResponse => _apiResponse;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchData() async {
    // Set loading state
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Fetch data from API service
      final response = await Apiservice.fetchData();

      // Update state
      _apiResponse = response;
      _isLoading = false;
      _errorMessage = null;
    } catch (e) {
      // Handle error
      _isLoading = false;
      _errorMessage = 'Failed to load data: ${e.toString()}';
    }

    // Notify listeners of state change
    notifyListeners();
  }
}
