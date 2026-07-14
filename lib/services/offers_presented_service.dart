// العروض التي قدمها المهني
// هذه العروض ظاهرة في صفحة (العروض المقدمة) عند المهني

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:graduation_project/processing/api_exception.dart';
import 'package:graduation_project/services/api_sercice.dart';

class OffersPresentedService {
  final ApiService _service = ApiService();

  // ── جلب كل العروض المقدمة من المحترف المسجّل دخوله (مع حالتها) ──────────
  Future<List<Map<String, dynamic>>> getSubmittedOffers() async {
    try {
      // TODO: تأكد من اسم الـ endpoint الصحيح
      final response = await _service.get('professional/offers');

      if (response == null) {
        throw Exception("الاستجابة فارغة من الخادم");
      }
      if (response.runtimeType.toString() == 'ApiError') {
        throw Exception("حدث خطأ في استجابة السيرفر");
      }

      if (response is List) {
        return response.cast<Map<String, dynamic>>();
      } else if (response is Map && response.containsKey('data')) {
        return (response['data'] as List).cast<Map<String, dynamic>>();
      } else {
        throw Exception("شكل البيانات غير متوقع من السيرفر");
      }
    } on DioException catch (e) {
      final error = ApiException.handelError(e);
      throw error.message;
    } catch (e) {
      debugPrint("in OffersPresentedService (getSubmittedOffers) $e");
      throw "حدث خطأ اثناء جلب العروض المقدمة";
    }
  }

  // ── تحديث حالة عرض واحد ─────────────────────────────────────────────────
  Future<void> updateStatus(int offerId, String newStatus) async {
    try {
      // TODO: تأكد من اسم الـ endpoint الصحيح
      final response = await _service.update('offers/$offerId/status', {
        "status": newStatus,
      });

      if (response.runtimeType.toString() == 'ApiError') {
        throw Exception("حدث خطأ أثناء تحديث الحالة");
      }
    } on DioException catch (e) {
      final error = ApiException.handelError(e);
      throw error.message;
    } catch (e) {
      debugPrint("in OffersPresentedService (updateStatus) $e");
      throw "حدث خطأ أثناء تحديث الحالة";
    }
  }
}
