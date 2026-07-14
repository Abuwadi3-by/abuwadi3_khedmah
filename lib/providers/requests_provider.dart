// معالجة الطلبات التي قدمها المستخدم
//

import 'package:flutter/material.dart';
import 'package:graduation_project/services/requests_service.dart';

class RequestsProvider extends ChangeNotifier {
  final RequestsService _service = RequestsService();

  List<Map<String, dynamic>> requests = [];
  bool isLoading = false;
  String? errorMessage;

  // اظهار الطلبات ---------------------
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

  // حذف الطلبات بعد قبول عرض واحد ---------------------
  void removeRequest(int requestId) {
    requests.removeWhere((r) => r['id'] == requestId);
    notifyListeners(); // ← requests page rebuilds instantly
  }

  // تحديث اشارة عدد العروض -------------
  void updateOffersCount(int requestId, int count) {
    final index = requests.indexWhere((r) => r['id'] == requestId);
    if (index != -1) {
      requests[index]['offers_count'] = count;
      notifyListeners();
    }
  }
}
