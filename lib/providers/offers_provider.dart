// اظهار العروض للطلبات المناسبة
import 'package:flutter/material.dart';
import 'package:graduation_project/services/offers_service.dart';

class OffersProvider extends ChangeNotifier {
  final OffersService _service = OffersService();

  List<Map<String, dynamic>> offers = [];
  Map<String, dynamic>? acceptedOffer;
  bool isLoading = false;
  bool isAccepting = false;
  bool isRejecting = false;
  String? errorMessage;

  // اظهار العروض الوهمية
  Future<void> fetchOffers(int requestId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      offers = await _service.getOffersByRequest(requestId);
      acceptedOffer = null;
    } catch (e) {
      errorMessage = "فشل تحميل العروض";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // قبول العرض -----------------------------------
  Future<void> acceptOffer(int offerId, int requestId) async {
    isAccepting = true;
    errorMessage = null;
    notifyListeners();

    final List<Map<String, dynamic>> previous = List.from(offers);

    try {
      // optimistic: keep only the accepted offer
      final index = offers.indexWhere((o) => o['id'] == offerId);
      if (index != -1) {
        acceptedOffer = Map.from(offers[index]);
        acceptedOffer!['status'] = 'مقبول';
      }
      offers = offers.where((o) => o['id'] == offerId).toList();
      notifyListeners();

      await _service.acceptOffer(offerId, requestId);
    } catch (e) {
      offers = previous;
      acceptedOffer = null;
      errorMessage = "فشل قبول العرض، حاول مجدداً";
      notifyListeners();
    } finally {
      isAccepting = false;
      notifyListeners();
    }
  }

  // رفض العرض ------ اختفاء العرض بشكل كامل ------------------
  Future<void> rejectOffer(int offerId) async {
    isRejecting = true;
    notifyListeners();

    // remove immediately — user intentionally rejected, no rollback
    offers.removeWhere((o) => o['id'] == offerId);
    notifyListeners();

    try {
      await _service.rejectOffer(offerId);
    } catch (_) {
      // even if API fails, keep it removed locally
      // the user's decision is final
      errorMessage = "تعذّر إرسال الرفض للخادم";
      notifyListeners();
    } finally {
      isRejecting = false;
      notifyListeners();
    }
  }

  // ── Update a professional's rating on their offer card ─────────────────────
  // Called after the user submits a rating from RatingPage
  void updateOfferRating(int professionalId, double newAverage) {
    bool changed = false;
    for (int i = 0; i < offers.length; i++) {
      if (offers[i]['professional_id'] == professionalId) {
        offers[i]['rate'] = newAverage;
        changed = true;
      }
    }
    // also update accepted offer if it exists
    if (acceptedOffer != null &&
        acceptedOffer!['professional_id'] == professionalId) {
      acceptedOffer!['rate'] = newAverage;
      changed = true;
    }
    if (changed) notifyListeners(); // ← offer cards rebuild
  }

  bool get hasAcceptedOffer => acceptedOffer != null;
}
