//

import 'package:flutter/material.dart';
import 'package:graduation_project/services/create_offer_service.dart';

class CreateOfferProvider extends ChangeNotifier {
  final CreateOfferService _service = CreateOfferService();

  bool isSubmitting = false;
  bool isSuccess = false;
  String? errorMessage;

  //  Submit offer --------------------------
  Future<void> submitOffer({
    required int requestId,
    required String price,
    required String details,
    required String estimatedTime,
  }) async {
    isSubmitting = true;
    isSuccess = false;
    errorMessage = null;
    notifyListeners();

    try {
      await _service.submitOffer(
        requestId: requestId,
        price: price,
        details: details,
        estimatedTime: estimatedTime,
      );
      isSuccess = true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  // التهيئة عند اغلاق الصفحة
  void reset() {
    isSubmitting = false;
    isSuccess = false;
    errorMessage = null;
    notifyListeners();
  }
}
