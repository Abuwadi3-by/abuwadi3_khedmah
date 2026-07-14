// lib/services/chat_service.dart

import 'package:dio/dio.dart';
import 'package:graduation_project/processing/dio_client.dart';

class ChatService {
  final Dio dio = DioClient().dio;

  // ── Fetch messages for a conversation ─────────────────────────────────────
  Future<List<Map<String, dynamic>>> getMessages(int conversationId) async {
    await Future.delayed(const Duration(milliseconds: 600));

    // ── Fake messages ──────────────────────────────────────────────────────
    // is_mine: true  → sent by the logged-in user (shown on left in RTL)
    // is_mine: false → received from the other person (shown on right in RTL)
    final Map<int, List<Map<String, dynamic>>> fakeMessages = {
      1: [
        {
          "id": 1,
          "content": "مرحباً، هل يمكنك إصلاح العطل الكهربائي؟",
          "is_mine": true,
          "created_at": "2026-06-01 09:00",
        },
        {
          "id": 2,
          "content": "نعم بالتأكيد، ما هو نوع العطل؟",
          "is_mine": false,
          "created_at": "2026-06-01 09:05",
        },
        {
          "id": 3,
          "content": "الكهرباء انقطعت عن غرفة النوم فقط",
          "is_mine": true,
          "created_at": "2026-06-01 09:10",
        },
        {
          "id": 4,
          "content": "غالباً مشكلة في القاطع، سأصل خلال ساعة",
          "is_mine": false,
          "created_at": "2026-06-01 09:15",
        },
        {
          "id": 5,
          "content": "سأصل خلال ساعة إن شاء الله",
          "is_mine": false,
          "created_at": "2026-06-01 10:30",
        },
      ],
      2: [
        {
          "id": 6,
          "content": "الغسالة تصدر صوتاً غريباً أثناء الدوران",
          "is_mine": true,
          "created_at": "2026-05-31 13:00",
        },
        {
          "id": 7,
          "content": "هل الصوت من أسفل الغسالة أم من الطبل؟",
          "is_mine": false,
          "created_at": "2026-05-31 13:10",
        },
        {
          "id": 8,
          "content": "من أسفلها",
          "is_mine": true,
          "created_at": "2026-05-31 13:15",
        },
        {
          "id": 9,
          "content": "تم الانتهاء من الإصلاح",
          "is_mine": false,
          "created_at": "2026-05-31 14:15",
        },
      ],
      3: [
        {
          "id": 10,
          "content": "نريد دهان غرفتين باللون الأبيض",
          "is_mine": true,
          "created_at": "2026-05-30 08:50",
        },
        {
          "id": 11,
          "content": "ما هو لون الدهان المطلوب؟",
          "is_mine": false,
          "created_at": "2026-05-30 09:00",
        },
      ],
    };

    return fakeMessages[conversationId] ?? [];
  }

  // ── Send a message ─────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> sendMessage({
    required int conversationId,
    required String content,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // fake response — returns the new message as saved
    return {
      "id": DateTime.now().millisecondsSinceEpoch,
      "content": content,
      "is_mine": true,
      "created_at": DateTime.now().toString().substring(0, 16),
    };
  }

  // ── Mark all messages in conversation as read ──────────────────────────────
  Future<void> markAsRead(int conversationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
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
