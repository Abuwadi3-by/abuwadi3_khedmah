// لارسال تفاصيل العرض الى قاعدة البيانات

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:graduation_project/processing/api_exception.dart';
import 'package:graduation_project/services/api_sercice.dart';

class CreateOfferService {
  final ApiService _service = ApiService();

  // ارسال العرض الى طلب محدد -------------------------------
  Future<void> submitOffer({
    required int requestId,
    required String price,
    required String details,
    required String estimatedTime,
  }) async {
    try {
      final response = await _service.post('service-requests/$requestId/offers', {
        "price": price,
        "details": details,
        "eta": estimatedTime,
      });

      if (response == null) {
        throw Exception("الاستجابة فارغة من الخادم");
      }
      if (response.runtimeType.toString() == 'ApiError') {
        throw Exception("حدث خطأ أثناء إرسال العرض");
      }
    } on DioException catch (e) {
      final error = ApiException.handelError(e);
      throw error.message;
    } catch (e) {
      debugPrint("in CreateOfferService (submitOffer) $e");
      throw "حدث خطأ أثناء إرسال العرض";
    }
  }
}
