import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:graduation_project/model/category_model.dart';
import 'package:graduation_project/processing/api_exception.dart';
import 'package:graduation_project/services/api_service.dart';

class CategoryService {
  final ApiService _service = ApiService();

  Future<List<CategoriesModel>> getcategories() async {
    try {
      final response = await _service.get('service-categories');
      if (response == null) {
        throw Exception("الاستجابة فارغة من الخادم");
      }
      if (response.runtimeType.toString() == 'ApiError') {
        throw Exception(
          "حدث خطأ في استجابة السيرفر. تأكد من الرابط أو قاعدة البيانات.",
        );
      }
      if (response is List) {
        return response.map((item) => CategoriesModel.fromJson(item)).toList();
      } else if (response is Map && response.containsKey('data')) {
        return (response['data'] as List)
            .map((item) => CategoriesModel.fromJson(item))
            .toList();
      } else {
        throw Exception("شكل البيانات غير متوقع من السيرفر");
      }
    } on DioException catch (e) {
      final error = ApiException.handelError(e);
      throw error.message;
    } catch (e) {
      debugPrint("in CategoryService (getcategories) $e");
      throw "حدث حطأ اثناء جلب التصنيفات ";
    }
  }
}
