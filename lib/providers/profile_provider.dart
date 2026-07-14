// لعرض البيانات القادمة من قاعدة البيانات في الصفحة المناسبة

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graduation_project/services/profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _service = ProfileService();

  Map<String, dynamic>? profile;
  File? localAvatar; // picked image before uploading
  bool isLoading = false;
  bool isSaving = false;
  bool isUploading = false;
  String? errorMessage;
  String? successMessage;

  // ── Role helpers
  bool get isProfessional => profile?['role'] == 'professional';
  String get role => profile?['role'] ?? 'customer';

  // ── Current avatar to display
  File? get avatarFile => localAvatar;
  String? get avatarUrl => profile?['avatar_url'] as String?;
  bool get hasAvatar =>
      (localAvatar != null) || (avatarUrl != null && avatarUrl!.isNotEmpty);

  // ── Fetch profile
  Future<void> fetchProfile() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      profile = await _service.getProfile();
      localAvatar = null; // clear any previously picked image
    } catch (e) {
      errorMessage = "فشل تحميل بيانات الملف الشخصي";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── Pick & upload avatar
  Future<void> pickAndUploadAvatar(File pickedFile) async {
    // 1 — show locally first (instant feedback)
    localAvatar = pickedFile;
    notifyListeners();

    // 2 — upload to server
    isUploading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final String newUrl = await _service.uploadAvatar(pickedFile, role);

      // 3 — save the returned URL into profile
      profile = {...?profile, 'avatar_url': newUrl};
      localAvatar = null; // clear local file — we now have a server URL
    } catch (e) {
      // upload failed — keep showing local file but flag the error
      errorMessage = "فشل رفع الصورة، حاول مجدداً";
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }

  // ── Update profile text data
  Future<void> updateProfile(Map<String, dynamic> updatedData) async {
    isSaving = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      await _service.updateProfile(updatedData);
      profile = {...?profile, ...updatedData};
      successMessage = "تم تحديث الملف الشخصي بنجاح";
    } catch (e) {
      errorMessage = "فشل تحديث البيانات، حاول مجدداً";
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
