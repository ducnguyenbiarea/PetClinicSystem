import 'dart:convert';
import 'dart:js_interop';
import 'package:web/web.dart' as web;
import '../constants/app_constants.dart';
import 'package:flutter/foundation.dart';

@JS('fetch')
external JSPromise<JSObject> _fetch(String url, JSObject? options);

@JS('JSON.stringify')
external JSString _jsonStringify(JSObject obj);

@JS('JSON.parse')
external JSObject _jsonParse(JSString str);

@JS()
@anonymous
extension type FetchOptions._(JSObject _) implements JSObject {
  external factory FetchOptions({
    String? method,
    JSObject? headers,
    String? body,
    String? credentials,
  });
}

@JS()
@anonymous
extension type FetchResponse._(JSObject _) implements JSObject {
  external JSPromise<JSString> text();
  external JSPromise<JSObject> json();
  external int get status;
  external bool get ok;
  external JSString get statusText;
  external JSObject get headers;
}

@JS()
@anonymous
extension type ResponseHeaders._(JSObject _) implements JSObject {
  external JSString? get(String name);
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final String baseUrl = AppConstants.baseUrl;

  // Handle API response and extract JSESSIONID
  Future<dynamic> _handleResponse(FetchResponse response) async {
    final statusCode = response.status;
    
    // Extract and store JSESSIONID from Set-Cookie header if present
    _extractJSessionId(response);
    
    if (statusCode >= 200 && statusCode < 300) {
      try {
        final jsonResponse = await response.json().toDart;
        return _jsObjectToDart(jsonResponse);
      } catch (e) {
        // If response is not JSON, try to get text
        try {
          final textResponse = await response.text().toDart;
          return {'data': textResponse.toDart, 'success': true};
        } catch (e2) {
          return {'success': true};
        }
      }
    } else {
      try {
        final errorResponse = await response.json().toDart;
        final errorData = _jsObjectToDart(errorResponse);
        throw ApiException(
          message: errorData['message'] ?? 'Unknown error',
          statusCode: statusCode,
          errors: errorData['errors'],
        );
      } catch (e) {
        if (e is ApiException) rethrow;
        throw ApiException(
          message: 'HTTP $statusCode: ${response.statusText.toDart}',
          statusCode: statusCode,
        );
      }
    }
  }

  // Extract JSESSIONID from response headers
  void _extractJSessionId(FetchResponse response) {
    try {
      final headers = response.headers as ResponseHeaders;
      final setCookie = headers.get('set-cookie')?.toDart;
      
      if (setCookie != null && setCookie.contains('JSESSIONID')) {
        // Extract JSESSIONID value
        final regex = RegExp(r'JSESSIONID=([^;]+)');
        final match = regex.firstMatch(setCookie);
        if (match != null) {
          final jsessionId = match.group(1);
          // Set the cookie in the browser
          web.document.cookie = 'JSESSIONID=$jsessionId; path=/; SameSite=Lax';
          debugPrint('JSESSIONID extracted and set: $jsessionId');
        }
      }
    } catch (e) {
      debugPrint('Error extracting JSESSIONID: $e');
    }
  }

  // Convert JS object to Dart object
  dynamic _jsObjectToDart(JSObject jsObject) {
    final jsonString = _jsonStringify(jsObject).toDart;
    return json.decode(jsonString);
  }

  // Convert Dart object to JS object
  JSObject _dartToJSObject(Map<String, dynamic> dartObject) {
    final jsonString = json.encode(dartObject);
    return _jsonParse(jsonString.toJS);
  }

  // Create headers JS object
  JSObject _createHeaders(Map<String, String> headers) {
    return _dartToJSObject(headers.cast<String, dynamic>());
  }

  // Clear cookies (for logout)
  void clearCookies() {
    // Clear JSESSIONID and other session cookies
    final cookieNames = ['JSESSIONID', 'SESSION'];
    for (final name in cookieNames) {
      web.document.cookie = '$name=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
    }
    debugPrint('Cookies cleared');
  }

  // GET request
  Future<dynamic> get(String endpoint) async {
    try {
      final options = FetchOptions(
        method: 'GET',
        credentials: 'include', // This is crucial for cookies
        headers: _createHeaders({
          'Content-Type': 'application/json',
        }),
      );

      final response = await _fetch('$baseUrl$endpoint', options).toDart;
      return await _handleResponse(response as FetchResponse);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Network error: $e');
    }
  }

  // POST request
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final options = FetchOptions(
        method: 'POST',
        credentials: 'include', // This is crucial for cookies
        headers: _createHeaders({
          'Content-Type': 'application/json',
        }),
        body: body != null ? json.encode(body) : null,
      );

      final response = await _fetch('$baseUrl$endpoint', options).toDart;
      return await _handleResponse(response as FetchResponse);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Network error: $e');
    }
  }

  // POST request with form data (for login)
  Future<dynamic> postForm(String endpoint, Map<String, String> formData) async {
    try {
      final formBody = formData.entries
          .map((entry) => '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}')
          .join('&');

      final options = FetchOptions(
        method: 'POST',
        credentials: 'include', // This is crucial for cookies
        headers: _createHeaders({
          'Content-Type': 'application/x-www-form-urlencoded',
        }),
        body: formBody,
      );

      final response = await _fetch('$baseUrl$endpoint', options).toDart;
      return await _handleResponse(response as FetchResponse);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Network error: $e');
    }
  }

  // PUT request
  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final options = FetchOptions(
        method: 'PUT',
        credentials: 'include', // This is crucial for cookies
        headers: _createHeaders({
          'Content-Type': 'application/json',
        }),
        body: body != null ? json.encode(body) : null,
      );

      final response = await _fetch('$baseUrl$endpoint', options).toDart;
      return await _handleResponse(response as FetchResponse);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Network error: $e');
    }
  }

  // PATCH request
  Future<dynamic> patch(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final options = FetchOptions(
        method: 'PATCH',
        credentials: 'include', // This is crucial for cookies
        headers: _createHeaders({
          'Content-Type': 'application/json',
        }),
        body: body != null ? json.encode(body) : null,
      );

      final response = await _fetch('$baseUrl$endpoint', options).toDart;
      return await _handleResponse(response as FetchResponse);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Network error: $e');
    }
  }

  // DELETE request
  Future<dynamic> delete(String endpoint) async {
    try {
      final options = FetchOptions(
        method: 'DELETE',
        credentials: 'include', // This is crucial for cookies
        headers: _createHeaders({
          'Content-Type': 'application/json',
        }),
      );

      final response = await _fetch('$baseUrl$endpoint', options).toDart;
      return await _handleResponse(response as FetchResponse);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Network error: $e');
    }
  }

  // PATCH request with query parameters (for status updates)
  Future<dynamic> patchWithQuery(String endpoint, Map<String, String> queryParams) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
      
      final options = FetchOptions(
        method: 'PATCH',
        credentials: 'include', // This is crucial for cookies
        headers: _createHeaders({
          'Content-Type': 'application/json',
        }),
      );

      final response = await _fetch(uri.toString(), options).toDart;
      return await _handleResponse(response as FetchResponse);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Network error: $e');
    }
  }

  // GET request with query parameters
  Future<dynamic> getWithQuery(String endpoint, Map<String, String> queryParams) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
      
      final options = FetchOptions(
        method: 'GET',
        credentials: 'include', // This is crucial for cookies
        headers: _createHeaders({
          'Content-Type': 'application/json',
        }),
      );

      final response = await _fetch(uri.toString(), options).toDart;
      return await _handleResponse(response as FetchResponse);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Network error: $e');
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final List<String>? errors;

  ApiException({
    required this.message,
    this.statusCode,
    this.errors,
  });

  @override
  String toString() {
    if (errors != null && errors!.isNotEmpty) {
      return '$message\nErrors: ${errors!.join(', ')}';
    }
    return message;
  }
} 