// لجلب بيانات البروفيل الخاصة بالمهني والمستخدم

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:graduation_project/processing/api_exception.dart';
import 'package:graduation_project/services/api_sercice.dart';

class ProfileService {
  final ApiService _service = ApiService();

  // ── جلب بيانات البروفايل (بيتحدد تلقائياً customer/professional حسب التوكن) ─
  Future<Map<String, dynamic>> getProfile() async {
    try {
      // TODO: تأكد من اسم الـ endpoint الصحيح
      final response = await _service.get('profile');

      if (response == null) {
        throw Exception("الاستجابة فارغة من الخادم");
      }
      if (response.runtimeType.toString() == 'ApiError') {
        throw Exception("حدث خطأ أثناء جلب بيانات الملف الشخصي");
      }

      final data = response is Map && response.containsKey('data')
          ? response['data']
          : response;

      return Map<String, dynamic>.from(data);
    } on DioException catch (e) {
      final error = ApiException.handelError(e);
      throw error.message;
    } catch (e) {
      debugPrint("in ProfileService (getProfile) $e");
      throw "حدث خطأ أثناء جلب بيانات الملف الشخصي";
    }
  }

  // ── تحديث البيانات النصية بالبروفايل ───────────────────────────────────
  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      // TODO: تأكد من اسم الـ endpoint الصحيح
      final response = await _service.update('profile', data);

      if (response.runtimeType.toString() == 'ApiError') {
        throw Exception("حدث خطأ أثناء تحديث البيانات");
      }
    } on DioException catch (e) {
      final error = ApiException.handelError(e);
      throw error.message;
    } catch (e) {
      debugPrint("in ProfileService (updateProfile) $e");
      throw "حدث خطأ أثناء تحديث البيانات";
    }
  }

  // ── رفع صورة البروفايل ─────────────────────────────────────────────────
  // role منمررها بس لغايات توافق التوقيع القديم، السيرفر بيعرف نوع
  // المستخدم أصلاً من التوكن ومنيح يحدد وحده وين يخزن الصورة
  Future<String> uploadAvatar(File imageFile, String role) async {
    try {
      // TODO: تأكد من اسم الـ endpoint واسم حقل الصورة ("avatar")
      // وشكل الاستجابة (افتراض حالياً: {"avatar_url": "..."})
      final response = await _service.postMultipart(
        'profile/avatar',
        fields: {},
        files: {"avatar": imageFile},
      );

      if (response == null) {
        throw Exception("الاستجابة فارغة من الخادم");
      }
      if (response.runtimeType.toString() == 'ApiError') {
        throw Exception("حدث خطأ أثناء رفع الصورة");
      }

      final data = response is Map && response.containsKey('data')
          ? response['data']
          : response;

      return (data['avatar_url'] ?? data['url']).toString();
    } on DioException catch (e) {
      final error = ApiException.handelError(e);
      throw error.message;
    } catch (e) {
      debugPrint("in ProfileService (uploadAvatar) $e");
      throw "حدث خطأ أثناء رفع الصورة";
    }
  }
}
