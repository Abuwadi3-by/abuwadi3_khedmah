// مقدمين الخدمة الموجودين في التطبيق
// يعرض المهنيين حسب التصنيف

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:graduation_project/processing/api_exception.dart';
import 'package:graduation_project/services/api_sercice.dart';

class ProfessionalsService {
  final ApiService _service = ApiService();

  Future<List<Map<String, dynamic>>> getProfessionalsByCategory(
    String category,
  ) async {
    try {
      // TODO: تأكد من اسم الـ endpoint الصحيح وطريقة تمرير التصنيف
      // (query param زي بالأسفل، أو ممكن يكون /professionals/category/$category)
      final response = await _service.get(
        'professionals',
        queryParameters: {"category": category},
      );

      if (response == null) {
        throw Exception("الاستجابة فارغة من الخادم");
      }
      if (response.runtimeType.toString() == 'ApiError') {
        throw Exception(
          "حدث خطأ في استجابة السيرفر. تأكد من الرابط أو قاعدة البيانات.",
        );
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
      debugPrint("in ProfessionalsService (getProfessionalsByCategory) $e");
      throw "حدث خطأ اثناء جلب المحترفين";
    }
  }
}
