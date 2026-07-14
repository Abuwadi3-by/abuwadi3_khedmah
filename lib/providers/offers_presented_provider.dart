import 'package:flutter/material.dart';
import 'package:graduation_project/services/offers_presented_service.dart';

// معالجة العروض التي قدمها المنهي حسب حالتها
// العرض اما مقبول او مرفوض او قيد الانتظار

class OffersPresentedProvider extends ChangeNotifier {
  final OffersPresentedService _service = OffersPresentedService();

  List<Map<String, dynamic>> offers = [];
  bool isLoading = false;
  String? errorMessage;

  // ── Fetch all submitted offers — status comes from DB with each offer ─────
  Future<void> fetchSubmittedOffers() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      offers = await _service.getSubmittedOffers();
    } catch (e) {
      errorMessage = "فشل تحميل العروض المقدمة";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── Update status of one offer ─────────────────────────────────────────────
  Future<void> updateOfferStatus(int offerId, String newStatus) async {
    final index = offers.indexWhere((o) => o['id'] == offerId);
    if (index == -1) return;

    // save old status in case we need to roll back
    final String oldStatus = offers[index]['status'];

    // 1 — update locally first so UI responds instantly
    offers[index]['status'] = newStatus;
    notifyListeners();

    // 2 — sync with API
    try {
      await _service.updateStatus(offerId, newStatus);
    } catch (e) {
      // API failed — roll back to old status
      offers[index]['status'] = oldStatus;
      errorMessage = "فشل تحديث الحالة";
      notifyListeners();
    }
  }
}
