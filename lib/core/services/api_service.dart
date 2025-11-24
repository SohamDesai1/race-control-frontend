import 'dart:developer';
import 'package:dio/dio.dart';
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
  late final Dio _dio;
  final String _baseUrl = dotenv.env['API_BASE_URL']!;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          log('API Call: ${options.method} ${options.uri}');
          if (options.data != null) {
            log('Request body: ${options.data}');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          log(
            'Response: ${response.data} with status code: ${response.statusCode}',
          );
          handler.next(response);
        },
        onError: (error, handler) {
          log('API Error: ${error.message}');
          handler.next(error);
        },
      ),
    );
  }

  Future<ApiResponse> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        options: Options(headers: headers),
        queryParameters: queryParameters,
      );

      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ApiResponse> post(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: body,
        options: Options(headers: headers),
      );

      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ApiResponse> put(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: body,
        options: Options(headers: headers),
      );

      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ApiResponse> patch(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: body,
        options: Options(headers: headers),
      );

      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ApiResponse> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        options: Options(headers: headers),
      );

      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ApiResponse _processResponse(Response response) {
    final statusCode = response.statusCode ?? 0;
    final headers = <String, String>{};

    response.headers.forEach((name, values) {
      headers[name] = values.join(', ');
    });

    final body = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : <String, dynamic>{'data': response.data};

    return ApiResponse(body: body, statusCode: statusCode, headers: headers);
  }

  ApiException _handleDioError(DioException error) {
    final statusCode = error.response?.statusCode ?? 0;
    String message;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Send timeout';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Receive timeout';
        break;
      case DioExceptionType.badResponse:
        final responseData = error.response?.data;
        if (responseData is Map<String, dynamic>) {
          message =
              responseData['message'] ??
              responseData['error'] ??
              'Bad response';
        } else {
          message = 'Bad response';
        }
        break;
      case DioExceptionType.cancel:
        message = 'Request cancelled';
        break;
      case DioExceptionType.connectionError:
        message = 'Connection error';
        break;
      case DioExceptionType.unknown:
      default:
        message = error.message ?? 'Unknown error occurred';
        break;
    }

    return ApiException(statusCode: statusCode, message: message);
  }

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  void updateHeaders(Map<String, String> headers) {
    _dio.options.headers.addAll(headers);
  }

  void cancelRequests() {
    _dio.close();
  }
}
