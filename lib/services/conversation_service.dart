// lib/services/conversations_service.dart

import 'package:dio/dio.dart';
import 'package:graduation_project/processing/dio_client.dart';

class ConversationsService {
  final Dio dio = DioClient().dio;

  // ── Fetch all conversations for the logged-in user ─────────────────────────
  // Laravel returns the "other person" based on who is logged in:
  //   if user      → returns professional's name in other_person_name
  //   if professional → returns user's name in other_person_name
  Future<List<Map<String, dynamic>>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 700)); // fake loading

    // ── Fake data ──────────────────────────────────────────────────────────
    // Change role field in ProfileService to test both views:
    //   "user"         → sees professionals
    //   "professional" → sees users
    return [
      {
        "id": 1,
        "request_id": 1,
        "request_title": "إصلاح عطل كهربائي في المنزل",
        "other_person_id": 10,
        "other_person_name": "المهندس أحمد",
        "last_message": "سأصل خلال ساعة إن شاء الله",
        "last_message_at": "2026-06-01 10:30",
        "unread_count": 2,
      },
      {
        "id": 2,
        "request_id": 2,
        "request_title": "صيانة غسالة أوتوماتيك",
        "other_person_id": 11,
        "other_person_name": "الفني خالد",
        "last_message": "تم الانتهاء من الإصلاح",
        "last_message_at": "2026-05-31 14:15",
        "unread_count": 0,
      },
      {
        "id": 3,
        "request_id": 3,
        "request_title": "دهان غرفتين",
        "other_person_id": 12,
        "other_person_name": "المهندس علي",
        "last_message": "ما هو لون الدهان المطلوب؟",
        "last_message_at": "2026-05-30 09:00",
        "unread_count": 1,
      },
    ];
  }

  // ── Error handler ──────────────────────────────────────────────────────────
  String handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout)
      return "انتهت مهلة الاتصال";
    if (e.response?.statusCode == 401) return "غير مصرح، سجّل دخولك مجدداً";
    if (e.response?.statusCode == 500) return "خطأ في الخادم، حاول لاحقاً";
    return "حدث خطأ غير متوقع";
  }
}
