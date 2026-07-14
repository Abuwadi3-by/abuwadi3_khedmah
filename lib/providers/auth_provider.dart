//

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graduation_project/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _service.register(name: name, email: email, password: password);
      return true; // عند النجاح الانتقال الى الصفحة التالية
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false; // عند الفشل اظهار رسالة خطأ
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── Save extra info (step 2) ───────────────────────────────────────────────
  Future<bool> saveUserInfo({
    required String phone,
    required String role,
    required String governorateId,
    String? cityId,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _service.saveUserInfo(
        phone: phone,
        role: role,
        governorateId: governorateId,
        cityId: cityId,
      );
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveProfessionalInfo({
    required String category,
    required String yearsExperience,
    required String description,
    required File toolsImage,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _service.saveProfessionalInfo(
        category: category,
        yearsExperience: yearsExperience,
        description: description,
        toolsImage: toolsImage,
      );
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login({required String email, required String password}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _service.login(email: email, password: password);
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _service.logout();
    notifyListeners();
  }

  //  ظهور خطأ في محاولة تسجيل الدخول الاولى
  // عند المحاولة من جديد تختفي الاخطاء من المحاولة السابقة
  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
