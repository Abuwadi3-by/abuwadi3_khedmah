// ارسال بيانات تسجيل الدخول و تسجيل الخروج الى قاعدة البيانات

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:graduation_project/model/user_model.dart';
import 'package:graduation_project/processing/api_exception.dart';
import 'package:graduation_project/processing/helper.dart';
import 'package:graduation_project/services/api_sercice.dart';

class AuthService {
  final ApiService _service = ApiService();

  // ── تسجيل حساب جديد (الخطوة 1: الاسم + الايميل + كلمة السر) ──────────────
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // TODO: تأكد من اسم الـ endpoint الصحيح لما توصلك وثائق الـ API
      final response = await _service.post('register', {
        "name": name,
        "email": email,
        "password": password,
      });

      if (response == null) {
        throw Exception("الاستجابة فارغة من الخادم");
      }
      if (response.runtimeType.toString() == 'ApiError') {
        throw Exception("حدث خطأ أثناء إنشاء الحساب. تأكد من البيانات");
      }

      final data = response is Map && response.containsKey('data')
          ? response['data']
          : response;

      // حفظ التوكن إذا رجع مباشرة بعد التسجيل
      final token = data['token'] ?? data['access_token'];
      if (token != null) {
        await PrefHelper.saveToken(token);
      }

      return UserModel.fromJson(data['user'] ?? data);
    } on DioException catch (e) {
      final error = ApiException.handelError(e);
      throw error.message;
    } catch (e) {
      debugPrint("in AuthService (register) $e");
      throw "حدث خطأ أثناء إنشاء الحساب";
    }
  }

  // ── حفظ البيانات الإضافية (الخطوة 2: الهاتف + الدور + المحافظة + المدينة) ─
  Future<void> saveUserInfo({
    required String phone,
    required String role,
    required String governorateId,
    String? cityId,
  }) async {
    try {
      // TODO: تأكد من اسم الـ endpoint الصحيح
      final response = await _service.post('user-info', {
        "phone": phone,
        "role": role,
        "governorate_id": governorateId,
        if (cityId != null) "city_id": cityId,
      });

      if (response == null) {
        throw Exception("الاستجابة فارغة من الخادم");
      }
      if (response.runtimeType.toString() == 'ApiError') {
        throw Exception("حدث خطأ أثناء حفظ البيانات");
      }
    } on DioException catch (e) {
      final error = ApiException.handelError(e);
      throw error.message;
    } catch (e) {
      debugPrint("in AuthService (saveUserInfo) $e");
      throw "حدث خطأ أثناء حفظ البيانات";
    }
  }

  // ── حفظ بيانات المحترف (الخطوة 3: التخصص + الخبرة + الوصف + صورة الأدوات)─
  Future<void> saveProfessionalInfo({
    required String category,
    required String yearsExperience,
    required String description,
    required File toolsImage,
  }) async {
    try {
      // TODO: تأكد من اسم الـ endpoint واسم حقل الصورة الصحيح ("tools_image")
      final response = await _service.postMultipart(
        'professional-info',
        fields: {
          "category": category,
          "years_experience": yearsExperience,
          "description": description,
        },
        files: {"tools_image": toolsImage},
      );

      if (response == null) {
        throw Exception("الاستجابة فارغة من الخادم");
      }
      if (response.runtimeType.toString() == 'ApiError') {
        throw Exception("حدث خطأ أثناء حفظ بيانات المحترف");
      }
    } on DioException catch (e) {
      final error = ApiException.handelError(e);
      throw error.message;
    } catch (e) {
      debugPrint("in AuthService (saveProfessionalInfo) $e");
      throw "حدث خطأ أثناء حفظ بيانات المحترف";
    }
  }

  // ── تسجيل الدخول ───────────────────────────────────────────────────────
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      // TODO: تأكد من اسم الـ endpoint الصحيح
      final response = await _service.post('login', {
        "email": email,
        "password": password,
      });

      if (response == null) {
        throw Exception("الاستجابة فارغة من الخادم");
      }
      if (response.runtimeType.toString() == 'ApiError') {
        throw Exception("البريد الإلكتروني أو كلمة السر غير صحيحة");
      }

      final data = response is Map && response.containsKey('data')
          ? response['data']
          : response;

      final token = data['token'] ?? data['access_token'];
      if (token == null) {
        throw Exception("لم يتم استلام رمز الدخول من الخادم");
      }
      await PrefHelper.saveToken(token);

      return UserModel.fromJson(data['user'] ?? data);
    } on DioException catch (e) {
      final error = ApiException.handelError(e);
      throw error.message;
    } catch (e) {
      debugPrint("in AuthService (login) $e");
      throw "حدث خطأ أثناء تسجيل الدخول";
    }
  }

  // ── تسجيل الخروج ───────────────────────────────────────────────────────
  Future<void> logout() async {
    try {
      // TODO: تأكد من اسم الـ endpoint الصحيح (قد لا يحتاج نداء API أصلاً)
      await _service.post('logout', null);
    } on DioException catch (_) {
      // حتى لو فشل نداء السيرفر، لازم نحذف التوكن محلياً بأي حال
    } finally {
      await PrefHelper.clearToken();
    }
  }
}
