// اظهار المهنيين على حسب التصنيف المسجلين فيه

import 'package:flutter/material.dart';
import 'package:graduation_project/services/professional_service.dart';

class ProfessionalsProvider extends ChangeNotifier {
  final ProfessionalsService _service = ProfessionalsService();

  List<Map<String, dynamic>> professionals = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchProfessionals(String category) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      professionals = await _service.getProfessionalsByCategory(category);
    } catch (e) {
      errorMessage = "فشل تحميل المختصين";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateProfessionalRating(int professionalId, double newAverage) {
    final index = professionals.indexWhere((p) => p['id'] == professionalId);
    if (index != -1) {
      professionals[index]['rate'] = newAverage;
      notifyListeners(); // ← professional card rebuilds with new rating
    }
  }
}
