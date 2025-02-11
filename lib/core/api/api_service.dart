import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService(String baseUrl)
      : _dio = Dio(BaseOptions(baseUrl: baseUrl)) {
    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  Future<Response<T>> sendRequest<T>({
    required String method,
    required String endpoint,
    bool isAuthRequired = false,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    T Function(dynamic)? decoder,
  }) async {
    try {
      final effectiveHeaders = {
        ...?headers,
        if (isAuthRequired) 'Authorization': 'Bearer ${await _getAuthToken()}',
      };

      final response = await _dio.request<T>(
        endpoint,
        options: Options(method: method, headers: effectiveHeaders),
        queryParameters: queryParameters,
        data: body,
      );

      if (decoder != null) {
        return Response<T>(
          requestOptions: response.requestOptions,
          data: decoder(response.data),
        );
      }

      return response;
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        final tokenRefreshed = await _refreshToken();

        if (tokenRefreshed) {
          return await _retryRequest<T>(
            method: method,
            endpoint: endpoint,
            headers: headers,
            queryParameters: queryParameters,
            body: body,
            decoder: decoder,
          );
        } else {
          throw Exception("Session expired. Please log in again.");
        }
      }
      _handleError(error);
      rethrow;
    }
  }

  Future<Response<T>> getRequest<T>(
      String endpoint, {
        bool isAuthRequired = false,
        Map<String, dynamic>? queryParameters,
        Map<String, String>? headers,
        T Function(dynamic)? decoder,
      }) =>
      sendRequest<T>(
        method: 'GET',
        endpoint: endpoint,
        isAuthRequired: isAuthRequired,
        queryParameters: queryParameters,
        headers: headers,
        decoder: decoder,
      );

  Future<Response<T>> postRequest<T>(
      String endpoint, {
        bool isAuthRequired = false,
        Map<String, dynamic>? body,
        Map<String, String>? headers,
        T Function(dynamic)? decoder,
      }) =>
      sendRequest<T>(
        method: 'POST',
        endpoint: endpoint,
        isAuthRequired: isAuthRequired,
        body: body,
        headers: headers,
        decoder: decoder,
      );

  Future<Response<T>> putRequest<T>(
      String endpoint, {
        bool isAuthRequired = false,
        Map<String, dynamic>? body,
        Map<String, String>? headers,
        T Function(dynamic)? decoder,
      }) =>
      sendRequest<T>(
        method: 'PUT',
        endpoint: endpoint,
        isAuthRequired: isAuthRequired,
        body: body,
        headers: headers,
        decoder: decoder,
      );

  Future<Response<T>> deleteRequest<T>(
      String endpoint, {
        bool isAuthRequired = false,
        Map<String, dynamic>? queryParameters,
        Map<String, String>? headers,
        T Function(dynamic)? decoder,
      }) =>
      sendRequest<T>(
        method: 'DELETE',
        endpoint: endpoint,
        isAuthRequired: isAuthRequired,
        queryParameters: queryParameters,
        headers: headers,
        decoder: decoder,
      );

  Future<String> _getAuthToken() async {
    return "";
  }

  Future<bool> _refreshToken() async {
    return false;
  }

  Future<Response<T>> _retryRequest<T>({
    required String method,
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    T Function(dynamic)? decoder,
  }) async {
    return sendRequest<T>(
      method: method,
      endpoint: endpoint,
      queryParameters: queryParameters,
      headers: headers,
      body: body,
      decoder: decoder,
    );
  }

  void _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        throw Exception('Connection timeout, please try again later.');
      case DioExceptionType.receiveTimeout:
        throw Exception('Receive timeout, please try again later.');
      case DioExceptionType.badResponse:
        throw Exception('Error: ${error.response?.statusCode} - ${error.response?.statusMessage}');
      default:
        throw Exception('Unexpected error: ${error.message}');
    }
  }
}
