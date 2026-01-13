import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/scan_result_model.dart';

class UrlScannerRemoteDataSource {
  final http.Client client;

  // static const String baseUrl = "http://192.168.137.244:5000";
  static const String baseUrl = "http://192.168.100.50:5000";

  UrlScannerRemoteDataSource({http.Client? client})
    : client = client ?? http.Client();

  /// Check URL for phishing threats
  Future<ScanResultModel> checkUrl(String url) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/check-url'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'url': url}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return ScanResultModel.fromJson(data, url);
      } else if (response.statusCode >= 500) {
        throw ServerException('Server error: ${response.statusCode}');
      } else {
        throw ServerException('Failed to check URL: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException('Unexpected error: $e');
    }
  }

  void dispose() {
    client.close();
  }
}

// Custom Exceptions
class ServerException implements Exception {
  final String message;
  ServerException(this.message);

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => message;
}
