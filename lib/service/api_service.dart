// import 'dart:convert';
// import 'package:cred/model/stack_item_model.dart';
// import 'package:http/http.dart' as http;

// class ApiService {
//   static const String url = "https://api.mocklets.com/p6764/test_mint";

//   static Future<List<StackItem>> fetchStackItems() async {
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body)['items'];
//       return data.map((item) => StackItem.fromJson(item)).toList();
//     } else {
//       throw Exception("Failed to load stack items");
//     }
//   }
// }
