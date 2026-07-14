// الطلبات عند المهني
// الطلبات المتاحة الان (بناءً على تخصص المحترف المسجّل دخوله)

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:graduation_project/processing/api_exception.dart';
import 'package:graduation_project/services/api_sercice.dart';

class ProfessionalRequestsService {
  final ApiService _service = ApiService();

  Future<List<Map<String, dynamic>>> getRequests() async {
    try {
      // TODO: تأكد من اسم الـ endpoint الصحيح
      // (السيرفر لازم يعرف المحترف المسجّل دخوله من التوكن ويفلتر الطلبات على تخصصه)
      final response = await _service.get('professional-requests');

      if (response == null) {
        throw Exception("الاستجابة فارغة من الخادم");
      }
      if (response.runtimeType.toString() == 'ApiError') {
        throw Exception("حدث خطأ في استجابة السيرفر");
      }

      if (response is List) {
        return response.cast<Map<String, dynamic>>();
      } else if (response is Map && response.containsKey('data')) {
        return (response['data'] as List).cast<Map<String, dynamic>>();
      } else {
        throw Exception("شكل البيانات غير متوقع من السيرفر");
      }
    } on DioException catch (e) {
      final error = ApiException.handelError(e);
      throw error.message;
    } catch (e) {
      debugPrint("in ProfessionalRequestsService (getRequests) $e");
      throw "حدث خطأ اثناء جلب الطلبات";
    }
  }
}
