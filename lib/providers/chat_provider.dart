// lib/providers/chat_provider.dart

import 'package:flutter/material.dart';
import 'package:graduation_project/services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _service = ChatService();

  List<Map<String, dynamic>> messages = [];
  bool isLoading = false;
  bool isSending = false;
  String? errorMessage;

  // ── Fetch messages for a conversation ─────────────────────────────────────
  Future<void> fetchMessages(int conversationId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      messages = await _service.getMessages(conversationId);
      // mark as read silently
      _service.markAsRead(conversationId);
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── Send a message ─────────────────────────────────────────────────────────
  Future<void> sendMessage({
    required int conversationId,
    required String content,
  }) async {
    if (content.trim().isEmpty) return;

    isSending = true;
    notifyListeners();

    // optimistic: add message instantly before API responds
    final optimistic = {
      "id": DateTime.now().millisecondsSinceEpoch,
      "content": content.trim(),
      "is_mine": true,
      "created_at": DateTime.now().toString().substring(0, 16),
      "pending": true, // shows a clock icon while sending
    };
    messages.add(optimistic);
    notifyListeners();

    try {
      final saved = await _service.sendMessage(
        conversationId: conversationId,
        content: content.trim(),
      );

      // replace optimistic message with real one from server
      final index = messages.indexWhere((m) => m['id'] == optimistic['id']);
      if (index != -1) {
        messages[index] = {...saved, 'pending': false};
        notifyListeners();
      }
    } catch (e) {
      // mark message as failed
      final index = messages.indexWhere((m) => m['id'] == optimistic['id']);
      if (index != -1) {
        messages[index] = {...optimistic, 'failed': true, 'pending': false};
        notifyListeners();
      }
      errorMessage = "فشل إرسال الرسالة";
    } finally {
      isSending = false;
      notifyListeners();
    }
  }

  // ── Add incoming message (called by Pusher when real-time is set up) ───────
  void addIncomingMessage(Map<String, dynamic> message) {
    messages.add({...message, 'is_mine': false});
    notifyListeners();
  }

  // ── Clear when leaving the chat ────────────────────────────────────────────
  void clear() {
    messages = [];
    isLoading = false;
    isSending = false;
    errorMessage = null;
    notifyListeners();
  }
}
