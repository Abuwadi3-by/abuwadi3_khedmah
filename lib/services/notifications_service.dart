// استقبال الاشعارات من الداتا بيز و معالجتها

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:graduation_project/processing/api_exception.dart';
import 'package:graduation_project/services/api_sercice.dart';

class NotificationsService {
  final ApiService _service = ApiService();

  // ── جلب كل إشعارات المستخدم المسجّل دخوله ─────────────────────────────
  Future<List<Map<String, dynamic>>> getNotifications() async {
    try {
      // TODO: تأكد من اسم الـ endpoint الصحيح
      final response = await _service.get('notifications');

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
      debugPrint("in NotificationsService (getNotifications) $e");
      throw "حدث خطأ اثناء جلب الإشعارات";
    }
  }

  // ── تحديد إشعار واحد كمقروء ─────────────────────────────────────────────
  Future<void> markAsRead(int id) async {
    try {
      // TODO: تأكد من اسم الـ endpoint الصحيح
      final response = await _service.update('notifications/$id/read', null);

      if (response.runtimeType.toString() == 'ApiError') {
        throw Exception("حدث خطأ أثناء تحديث الإشعار");
      }
    } on DioException catch (e) {
      final error = ApiException.handelError(e);
      throw error.message;
    } catch (e) {
      debugPrint("in NotificationsService (markAsRead) $e");
      throw "حدث خطأ أثناء تحديث الإشعار";
    }
  }

  // ── تحديد كل الإشعارات كمقروءة ──────────────────────────────────────────
  Future<void> markAllAsRead() async {
    try {
      // TODO: تأكد من اسم الـ endpoint الصحيح
      final response = await _service.update('notifications/read-all', null);

      if (response.runtimeType.toString() == 'ApiError') {
        throw Exception("حدث خطأ أثناء تحديث الإشعارات");
      }
    } on DioException catch (e) {
      final error = ApiException.handelError(e);
      throw error.message;
    } catch (e) {
      debugPrint("in NotificationsService (markAllAsRead) $e");
      throw "حدث خطأ أثناء تحديث الإشعارات";
    }
  }
}
