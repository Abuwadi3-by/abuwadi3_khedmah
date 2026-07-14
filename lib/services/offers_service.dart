// هذه العروض التي قدمها المهني
// وتلقى هذه العروض المستخدم كل طلب له عدد من العروض

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:graduation_project/processing/api_exception.dart';
import 'package:graduation_project/services/api_sercice.dart';

class OffersService {
  final ApiService _service = ApiService();

  // ── جلب العروض الخاصة بطلب معين (عبر تفاصيل الطلب نفسه) ────────────────
  Future<List<Map<String, dynamic>>> getOffersByRequest(int requestId) async {
    try {
      final response = await _service.get('service-requests/$requestId');

      if (response == null) {
        throw Exception("الاستجابة فارغة من الخادم");
      }
      if (response.runtimeType.toString() == 'ApiError') {
        throw Exception("حدث خطأ في استجابة السيرفر");
      }

      final data = (response as Map)['data'] as Map;
      final List offers = (data['offers'] as List?) ?? [];

      // تطبيع البيانات لتطابق الحقول التي تتوقعها الشاشة (id, rate, provider, details)
      return offers.map<Map<String, dynamic>>((offer) {
        final professional = offer['professional'] as Map?;
        return {
          "id": offer['offer_id'],
          "provider": professional?['name'] ?? '',
          "rate": professional?['rating'] ?? 0,
          "details": offer['details'] ?? '',
          "price": offer['price'],
          "eta": offer['eta'],
          "status": offer['status'],
        };
      }).toList();
    } on DioException catch (e) {
      final error = ApiException.handelError(e);
      throw error.message;
    } catch (e) {
      debugPrint("in OffersService (getOffersByRequest) $e");
      throw "حدث خطأ اثناء جلب العروض";
    }
  }

  // ── قبول عرض → السيرفر يرفض باقي العروض تلقائياً ────────────────────────
  Future<void> acceptOffer(int offerId, int requestId) async {
    try {
      // TODO: تأكد من اسم الـ endpoint الصحيح (لم تصل صورة له بعد)
      final response = await _service.post(
        'service-requests/$requestId/offers/$offerId/accept',
        null,
      );

      if (response.runtimeType.toString() == 'ApiError') {
        throw Exception("حدث خطأ أثناء قبول العرض");
      }
    } on DioException catch (e) {
      final error = ApiException.handelError(e);
      throw error.message;
    } catch (e) {
      debugPrint("in OffersService (acceptOffer) $e");
      throw "حدث خطأ أثناء قبول العرض";
    }
  }

  // ── رفض عرض → يختفي نهائياً ──────────────────────────────────────────
  Future<void> rejectOffer(int offerId) async {
    try {
      // TODO: تأكد من اسم الـ endpoint الصحيح (لم تصل صورة له بعد)
      final response = await _service.post('offers/$offerId/reject', null);

      if (response.runtimeType.toString() == 'ApiError') {
        throw Exception("حدث خطأ أثناء رفض العرض");
      }
    } on DioException catch (e) {
      final error = ApiException.handelError(e);
      throw error.message;
    } catch (e) {
      debugPrint("in OffersService (rejectOffer) $e");
      throw "حدث خطأ أثناء رفض العرض";
    }
  }
}
