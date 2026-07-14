import 'dart:io';

import 'package:dio/dio.dart';
import 'package:graduation_project/processing/api_exception.dart';
import 'package:graduation_project/processing/dio_client.dart';

class ApiService {
  final DioClient dioclient = DioClient();

  /// get
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final responsse = await dioclient.dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
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

  /// post مع ملفات (صور) - يستخدم FormData بدل Map عادي
  /// [fields] بيانات نصية عادية مثل: {"category": "..", "years_experience": ".."}
  /// [files] الملفات، المفتاح لازم يطابق اسم الحقل بالـ API مثل: {"tools_image": file}
  Future<dynamic> postMultipart(
    String endpoint, {
    required Map<String, dynamic> fields,
    Map<String, File> files = const {},
  }) async {
    try {
      final formMap = <String, dynamic>{...fields};
      for (final entry in files.entries) {
        formMap[entry.key] = await MultipartFile.fromFile(
          entry.value.path,
          filename: entry.value.path.split('/').last,
        );
      }
      final formData = FormData.fromMap(formMap);
      final responsse = await dioclient.dio.post(endpoint, data: formData);
      return responsse.data;
    } on DioException catch (err) {
      return ApiException.handelError(err);
    }
  }
}
