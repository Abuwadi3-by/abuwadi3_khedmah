// lib/providers/rating_provider.dart

import 'package:flutter/material.dart';
import '../services/rating_service.dart';

class RatingProvider extends ChangeNotifier {
  final RatingService _service = RatingService();

  int selectedRating = 0; // 0 = nothing selected yet
  bool isSubmitting = false;
  bool isSuccess = false;
  double? newAverage; // returned by API after submit
  String? errorMessage;

  void selectRating(int value) {
    selectedRating = value;
    errorMessage = null;
    notifyListeners();
  }

  // ارسال التقييم

  Future<double?> submitRating({required int professionalId}) async {
    if (selectedRating == 0) {
      errorMessage = "يرجى اختيار تقييم أولاً";
      notifyListeners();
      return null;
    }

    isSubmitting = true;
    isSuccess = false;
    errorMessage = null;
    notifyListeners();

    try {
      newAverage = await _service.submitRating(
        professionalId: professionalId,
        rating: selectedRating,
      );
      isSuccess = true;
      notifyListeners();
      return newAverage;
    } catch (e) {
      errorMessage = "فشل ارسال التقييم , حاول مجددا";
      debugPrint("Rating Provider Error : $e");
      notifyListeners();
      return null;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  // تفريغ القيم عند الخروج من الصفحة
  void reset() {
    selectedRating = 0;
    isSubmitting = false;
    isSuccess = false;
    newAverage = null;
    errorMessage = null;
    notifyListeners();
  }
}
