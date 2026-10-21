import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthApiException implements Exception {
  final String message;
  final int? statusCode;
  final bool isNetworkError;

  const AuthApiException({
    required this.message,
    this.statusCode,
    this.isNetworkError = false,
  });

  @override
  String toString() => message;
}

class AuthApiService {
  AuthApiService({
    required this.baseUrl,
  });

  final String baseUrl;

  Future<Map<String, dynamic>> signup({
    required String phone,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'phone': phone,
        'password': password,
      }),
    );

    return _parseResponse(response);
  }

  Future<Map<String, dynamic>> login({required String phone, required String password,}) async {
    try {
      final response = await http
          .post(
        Uri.parse('$baseUrl/auth/login/json'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'phone': phone,
          'password': password,
        }),
      )
          .timeout(const Duration(seconds: 10));

      return _parseResponse(response);
    } on AuthApiException {
      rethrow;
    } on http.ClientException {
      throw const AuthApiException(
        message: 'Unable to connect to the authentication server.',
        isNetworkError: true,
      );
    } on FormatException {
      throw const AuthApiException(
        message: 'The authentication server URL is invalid.',
      );
    } catch (e) {
      if (e is Exception &&
          e.toString().contains('TimeoutException')) {
        throw const AuthApiException(
          message: 'The authentication server timed out.',
          isNetworkError: true,
        );
      }

      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCurrentUser({
    required String accessToken,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    return _parseResponse(response);
  }

  Map<String, dynamic> _parseResponse(
      http.Response response,
      ) {
    dynamic decoded;

    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      throw AuthApiException(
        message:
        'The server returned an invalid response '
            '(${response.statusCode}).',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      final message = decoded is Map
          ? decoded['detail']?.toString()
          : null;

      throw AuthApiException(
        message: message ??
            'Request failed (${response.statusCode}).',
        statusCode: response.statusCode,
      );
    }

    if (decoded is! Map<String, dynamic>) {
      throw const AuthApiException(
        message: 'Unexpected server response.',
      );
    }

    return decoded;
  }
}