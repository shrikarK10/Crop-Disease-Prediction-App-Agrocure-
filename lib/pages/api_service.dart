import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.1.20:8000";

  static Future<List<Map<String, dynamic>>> fetchPrediction() async {
    final response = await http.get(Uri.parse("$baseUrl/predict"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['predictions'] != null) {
        return List<Map<String, dynamic>>.from(data['predictions']);
      } else {
        throw Exception('Prediction data missing');
      }
    } else {
      throw Exception('Failed to fetch prediction');
    }
  }
}
