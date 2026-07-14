import 'package:flutter/foundation.dart';
import 'package:graduation_project/services/complaint_service.dart';

///

class ComplaintProvider extends ChangeNotifier {
  final ComplaintService _service = ComplaintService();

  bool isSubmitting = false;
  bool isSuccess = false;
  String? errorMessage;

  // ── Submit complaint
  Future<void> submitComplaint({
    required String complaintText,
    required int reportedUserId,
  }) async {
    isSubmitting = true;
    isSuccess = false;
    errorMessage = null;
    notifyListeners();

    try {
      await _service.submitComplaint(
        complaintText: complaintText,
        reportedUserId: reportedUserId,
      );
      isSuccess = true;
    } catch (e) {
      errorMessage = "فشل إرسال الشكوى، حاول مجدداً";
      debugPrint("ComplaintProvider.submitComplaint error: $e");
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  // ── Reset when page closes
  void reset() {
    isSubmitting = false;
    isSuccess = false;
    errorMessage = null;
    notifyListeners();
  }
}
