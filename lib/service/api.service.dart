import 'dart:convert';
import 'package:cred/models/api.model.dart';
import 'package:http/http.dart' as http;

class Apiservice {
  static Future<CredModel> fetchData() async {
    final response =
        await http.get(Uri.parse('https://api.mocklets.com/p6764/test_mint'));
    if (response.statusCode == 200) {
      return CredModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
