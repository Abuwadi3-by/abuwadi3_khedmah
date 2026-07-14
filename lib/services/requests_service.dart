// الطلبات التي قدمها المستخدم

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:graduation_project/processing/api_exception.dart';
import 'package:graduation_project/services/api_sercice.dart';

class RequestsService {
  final ApiService _service = ApiService();

  // ── جلب كل طلبات المستخدم الحالي ──────────────────────────────────────
  Future<List<Map<String, dynamic>>> getRequests() async {
    try {
      final response = await _service.get('customer/requests');

      if (response == null) {
        throw Exception("الاستجابة فارغة من الخادم");
      }
      if (response.runtimeType.toString() == 'ApiError') {
        throw Exception("حدث خطأ في استجابة السيرفر");
      }

      final List list = (response as Map)['data'] as List;

      // تطبيع البيانات لتطابق الحقول التي تتوقعها الشاشات (id, title, date)
      return list.map<Map<String, dynamic>>((item) {
        final category = item['category'] as Map?;
        return {
          "id": item['request_id'],
          "title": category?['name'] ?? '',
          "category_id": category?['id'],
          "date": item['created_at'],
          "description": item['description'],
          "address": item['address'],
          "photo_url": item['photo_url'],
          "status": item['status'],
          "offers_count": item['offers_count'] ?? 0,
        };
      }).toList();
    } on DioException catch (e) {
      final error = ApiException.handelError(e);
      throw error.message;
    } catch (e) {
      debugPrint("in RequestsService (getRequests) $e");
      throw "حدث خطأ اثناء جلب الطلبات";
    }
  }

  // ── حذف طلب ────────────────────────────────────────────────────────────
  Future<void> deleteRequest(int id) async {
    try {
      // TODO: تأكد من اسم الـ endpoint الصحيح (افتراض: service-requests/{id})
      final response = await _service.delete('service-requests/$id', null);

      if (response.runtimeType.toString() == 'ApiError') {
        throw Exception("حدث خطأ أثناء حذف الطلب");
      }
    } on DioException catch (e) {
      final error = ApiException.handelError(e);
      throw error.message;
    } catch (e) {
      debugPrint("in RequestsService (deleteRequest) $e");
      throw "حدث خطأ أثناء حذف الطلب";
    }
  }
}
