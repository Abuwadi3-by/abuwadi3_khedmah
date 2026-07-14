//

import 'package:graduation_project/services/api_service.dart';

class RatingService {
  final ApiService _api = ApiService();

  // ── Submit a rating for a professional
  Future<double> submitRating({
    required int professionalId,
    required int rating, // 1 – 10
  }) async {
    final response = await _api.post('ratings', {
      'professional_id': professionalId,
      'rating': rating,
    });

    final dynamic raw = response is Map ? response['new_average'] : null;
    return raw != null ? (raw as num).toDouble() : rating.toDouble();
  }
}
