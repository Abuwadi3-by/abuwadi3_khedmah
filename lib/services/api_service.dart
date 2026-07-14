import 'package:dio/dio.dart';
import 'package:graduation_project/processing/api_exception.dart';
import 'package:graduation_project/processing/dio_client.dart';

class ApiService {
  final DioClient dioclient = DioClient();

  /// get
  Future<dynamic> get(String endpoint) async {
    try {
      final responsse = await dioclient.dio.get(endpoint);
      return responsse.data;
    } on DioException catch (err) {
      return ApiException.handelError(err);
    }
  }

  /// post
  Future<dynamic> post(String endpoint, Map<String, dynamic>? body) async {
    try {
      final responsse = await dioclient.dio.post(endpoint, data: body);
      return responsse.data;
    } on DioException catch (err) {
      return ApiException.handelError(err);
    }
  }

  /// update /put
  Future<dynamic> update(String endpoint, Map<String, dynamic>? body) async {
    try {
      final responsse = await dioclient.dio.put(endpoint, data: body);
      return responsse.data;
    } on DioException catch (err) {
      return ApiException.handelError(err);
    }
  }

  /// delete
  Future<dynamic> delete(String endpoint, Map<String, dynamic>? body) async {
    try {
      final responsse = await dioclient.dio.delete(endpoint, data: body);
      return responsse.data;
    } on DioException catch (err) {
      return ApiException.handelError(err);
    }
  }
}
