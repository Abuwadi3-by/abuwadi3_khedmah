// استقبال المعلومات من الحقول من صفحة طلب خدمة وارسالها الى قاعدة البيانات

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:graduation_project/processing/api_exception.dart';
import 'package:graduation_project/services/api_sercice.dart';

class ServiceRequestService {
  final ApiService _service = ApiService();

  Future<void> createRequest({
    required int categoryId,
    required String address,
    required String details,
    File? image,
  }) async {
    try {
      final response = await _service.postMultipart(
        'service-requests',
        fields: {
          "category_id": categoryId.toString(),
          "address": address,
          "description": details,
        },
        files: image != null ? {"photo": image} : {},
      );

      if (response == null) {
        throw Exception("الاستجابة فارغة من الخادم");
      }
      if (response.runtimeType.toString() == 'ApiError') {
        throw Exception("حدث خطأ أثناء إرسال الطلب");
      }
      // الاستجابة الناجحة شكلها: { "message": "...", "request": {...} }
      // ما في داعي نستخدم محتوى "request" حالياً، بس منتأكد إنه وصل
    } on DioException catch (e) {
      final error = ApiException.handelError(e);
      throw error.message;
    } catch (e) {
      debugPrint("in ServiceRequestService (createRequest) $e");
      throw "حدث خطأ أثناء إرسال الطلب";
    }
  }
}
