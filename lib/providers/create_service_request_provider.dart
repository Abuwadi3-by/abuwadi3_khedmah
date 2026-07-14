//

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graduation_project/services/create_service_request_service.dart';

class ServiceRequestProvider extends ChangeNotifier {
  final ServiceRequestService _service = ServiceRequestService();

  File? selectedImage; // image picked by the user
  bool isSubmitting = false;
  bool isSuccess = false;
  String? errorMessage;

  // ── Pick image from camera or gallery
  void setImage(File image) {
    selectedImage = image;
    errorMessage = null;
    notifyListeners();
  }

  // ── Remove the selected image
  void removeImage() {
    selectedImage = null;
    notifyListeners();
  }

  Future<void> submitRequest({
    required int categoryId,
    required String address,
    required String details,
  }) async {
    isSubmitting = true;
    isSuccess = false;
    errorMessage = null;
    notifyListeners();

    try {
      await _service.createRequest(
        categoryId: categoryId,
        address: address,
        details: details,
        image: selectedImage, // null if user didn't pick one
      );

      isSuccess = true;
      selectedImage = null; // clear after success
    } catch (e) {
      errorMessage = "فشل إرسال الطلب، حاول مجدداً";
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  void reset() {
    selectedImage = null;
    isSubmitting = false;
    isSuccess = false;
    errorMessage = null;
    notifyListeners();
  }
}
