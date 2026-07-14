//المحفظة والعمليات على المحفظة

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:graduation_project/processing/api_exception.dart';
import 'package:graduation_project/services/api_sercice.dart';

class BalanceService {
  final ApiService _service = ApiService();

  // ── جلب الرصيد الحالي -------------------------
  Future<String> getBalance() async {
    try {
      // TODO: تأكد من اسم الـ endpoint واسم حقل الرصيد بالاستجابة ("balance")
      final response = await _service.get('balance');

      if (response == null) {
        throw Exception("الاستجابة فارغة من الخادم");
      }
      if (response.runtimeType.toString() == 'ApiError') {
        throw Exception("حدث خطأ أثناء جلب الرصيد");
      }

      final data = response is Map && response.containsKey('data')
          ? response['data']
          : response;

      return data['balance'].toString();
    } on DioException catch (e) {
      final error = ApiException.handelError(e);
      throw error.message;
    } catch (e) {
      debugPrint("in BalanceService (getBalance) $e");
      throw "حدث خطأ أثناء جلب الرصيد";
    }
  }

  // ── جلب سجل العمليات --------------------------
  Future<List<Map<String, String>>> getTransactions() async {
    try {
      // TODO: تأكد من اسم الـ endpoint الصحيح
      final response = await _service.get('transactions');

      if (response == null) {
        throw Exception("الاستجابة فارغة من الخادم");
      }
      if (response.runtimeType.toString() == 'ApiError') {
        throw Exception("حدث خطأ أثناء جلب العمليات");
      }

      final List list = response is List
          ? response
          : (response is Map && response.containsKey('data'))
              ? response['data'] as List
              : throw Exception("شكل البيانات غير متوقع من السيرفر");

      return list
          .map<Map<String, String>>(
            (item) => {
              "type": item['type'].toString(),
              "amount": item['amount'].toString(),
              "date": item['date'].toString(),
            },
          )
          .toList();
    } on DioException catch (e) {
      final error = ApiException.handelError(e);
      throw error.message;
    } catch (e) {
      debugPrint("in BalanceService (getTransactions) $e");
      throw "حدث خطأ أثناء جلب العمليات";
    }
  }

  // ── ايداع رصيد ------------------------------------------
  Future<void> deposit(String amount) async {
    try {
      // TODO: تأكد من اسم الـ endpoint الصحيح
      final response = await _service.post('balance/deposit', {
        "amount": amount,
      });

      if (response.runtimeType.toString() == 'ApiError') {
        throw Exception("حدث خطأ أثناء الإيداع");
      }
    } on DioException catch (e) {
      final error = ApiException.handelError(e);
      throw error.message;
    } catch (e) {
      debugPrint("in BalanceService (deposit) $e");
      throw "حدث خطأ أثناء الإيداع";
    }
  }

  // ── سحب رصيد -------------------------------
  Future<void> withdraw(String amount) async {
    try {
      // TODO: تأكد من اسم الـ endpoint الصحيح
      final response = await _service.post('balance/withdraw', {
        "amount": amount,
      });

      if (response.runtimeType.toString() == 'ApiError') {
        throw Exception("حدث خطأ أثناء السحب");
      }
    } on DioException catch (e) {
      final error = ApiException.handelError(e);
      throw error.message;
    } catch (e) {
      debugPrint("in BalanceService (withdraw) $e");
      throw "حدث خطأ أثناء السحب";
    }
  }
}
