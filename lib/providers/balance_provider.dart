import 'package:flutter/material.dart';
import 'package:graduation_project/services/balance_service.dart';

// العمليات الاساسية على المحفظة

class BalanceProvider extends ChangeNotifier {
  final BalanceService _service = BalanceService();

  // ── State ------------------------------------
  String balance = "0";
  List<Map<String, String>> transactions = [];
  bool isLoading = false;
  String? errorMessage;

  // ── Fetch both balance and transactions together ---------------------
  Future<void> fetchWalletData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // run both requests at the same time, don't wait one then the other
      final results = await Future.wait([
        _service.getBalance(),
        _service.getTransactions(),
      ]);

      balance = results[0] as String;
      transactions = results[1] as List<Map<String, String>>;
    } catch (e) {
      errorMessage = "فشل تحميل بيانات المحفظة";
    } finally {
      isLoading = false;
      notifyListeners(); // ← UI rebuilds here
    }
  }

  // ── Deposit -------------------------------ايداع رصيد
  Future<void> deposit(String amount) async {
    await _service.deposit(amount);
    await fetchWalletData(); // re-fetch → UI updates automatically
  }

  // ── Withdraw --------------------------------------- سحب الرصيد
  Future<void> withdraw(String amount) async {
    await _service.withdraw(amount);
    await fetchWalletData(); // re-fetch → UI updates automatically
  }
}
