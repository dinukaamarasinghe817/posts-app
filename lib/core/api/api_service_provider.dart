
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:postapp/core/api/api_service.dart';
import 'package:postapp/core/api/api_service_const.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(baseURL);
});
