import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiResponse {
  final Map<String, dynamic> body;
  final int statusCode;
  final Map<String, String> headers;

  ApiResponse({
    required this.body,
    required this.statusCode,
    required this.headers,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException ($statusCode): $message';
}

class ApiService {
  final String _baseUrl = dotenv.env['API_BASE_URL']!;

  Future<ApiResponse> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    headers ??= {
      'Content-Type': 'application/json',
    };
    log('API Call: $_baseUrl$endpoint with headers: $headers');
    final response = await http.get(
      Uri.parse('$_baseUrl$endpoint'),
      headers: headers,
    );

    return _processResponse(response);
  }

  Future<ApiResponse> post(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    headers ??= {
      'Content-Type': 'application/json',
    };
    final response = await http.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: headers,
      body: json.encode(body),
    );

    return _processResponse(response);
  }

  Future<ApiResponse> put(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    headers ??= {
      'Content-Type': 'application/json',
    };
    final response = await http.put(
      Uri.parse('$_baseUrl$endpoint'),
      headers: headers,
      body: json.encode(body),
    );

    return _processResponse(response);
  }

  Future<ApiResponse> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    headers ??= {
      'Content-Type': 'application/json',
    };
    final response = await http.delete(
      Uri.parse('$_baseUrl$endpoint'),
      headers: headers,
    );

    return _processResponse(response);
  }

  ApiResponse _processResponse(http.Response response) {
    final statusCode = response.statusCode;
    final headers = response.headers;
    final decodedBody = response.body.isNotEmpty
        ? json.decode(response.body)
        : <String, dynamic>{};
    log('Response: $decodedBody with status code: $statusCode');
    if (statusCode >= 200 && statusCode < 300) {
      return ApiResponse(
        body: decodedBody,
        statusCode: statusCode,
        headers: headers,
      );
    } else {
      throw ApiException(
        statusCode: statusCode,
        message: decodedBody['message'] ?? 'Unexpected error',
      );
    }
  }
}
