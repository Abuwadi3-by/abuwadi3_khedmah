// lib/providers/conversations_provider.dart

import 'package:flutter/material.dart';
import 'package:graduation_project/services/conversation_service.dart';

class ConversationsProvider extends ChangeNotifier {
  final ConversationsService _service = ConversationsService();

  List<Map<String, dynamic>> conversations = [];
  bool isLoading = false;
  String? errorMessage;

  // ── Total unread count (for nav bar badge) ─────────────────────────────────
  int get totalUnread =>
      conversations.fold(0, (sum, c) => sum + (c['unread_count'] as int? ?? 0));

  // ── Fetch conversations ────────────────────────────────────────────────────
  Future<void> fetchConversations() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      conversations = await _service.getConversations();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── Mark conversation as read locally ─────────────────────────────────────
  // called when user opens a conversation
  void markConversationRead(int conversationId) {
    final index = conversations.indexWhere((c) => c['id'] == conversationId);
    if (index != -1) {
      conversations[index]['unread_count'] = 0;
      notifyListeners();
    }
  }

  // ── Update last message (called after sending) ─────────────────────────────
  void updateLastMessage(int conversationId, String message) {
    final index = conversations.indexWhere((c) => c['id'] == conversationId);
    if (index != -1) {
      conversations[index]['last_message'] = message;
      conversations[index]['last_message_at'] = DateTime.now()
          .toString()
          .substring(0, 16);
      // move this conversation to the top
      final updated = conversations.removeAt(index);
      conversations.insert(0, updated);
      notifyListeners();
    }
  }
}
