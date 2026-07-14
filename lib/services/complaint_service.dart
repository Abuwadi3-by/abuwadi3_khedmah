import 'package:graduation_project/services/api_service.dart';

///
///
///
class ComplaintService {
  final ApiService _service = ApiService();

  // ── Submit a complaint ─────────────────────────────────────────────────────
  Future<void> submitComplaint({
    required String complaintText,
    required int reportedUserId, // ID of the person being complained about
  }) async {
    await _service.post('complaints', {
      'complaint': complaintText,
      'reported_user_id': reportedUserId,
    });

    ///
  }
}
