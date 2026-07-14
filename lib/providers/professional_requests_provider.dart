// الطلبات المتاحة للمهني
// يمكن للمهني رؤية تفاصيل الطلب و تقديم عرض له

import 'package:flutter/material.dart';
import 'package:graduation_project/services/professional_requests_service.dart';

class ProfessionalRequestsProvider extends ChangeNotifier {
  final ProfessionalRequestsService _service = ProfessionalRequestsService();

  List<Map<String, dynamic>> requests = [];
  Map<String, dynamic>? selected; // the request the professional tapped
  bool isLoading = false;
  String? errorMessage;

  // ── Fetch all requests assigned to this professional ──────────────────────
  Future<void> fetchRequests() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      requests = await _service.getRequests();
    } catch (e) {
      errorMessage = "فشل تحميل الطلبات";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── Select a request to view its details ──────────────────────────────────
  void selectRequest(Map<String, dynamic> request) {
    selected = request;
    notifyListeners();
  }
}
