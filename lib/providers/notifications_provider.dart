// lib/providers/notifications_provider.dart

import 'package:flutter/material.dart';
import 'package:graduation_project/services/notifications_service.dart';

class NotificationsProvider extends ChangeNotifier {
  final NotificationsService _service = NotificationsService();

  List<Map<String, dynamic>> notifications = [];
  bool isLoading = false;
  String? errorMessage;

  // عدد الرسائل الغير مقروئة
  int get unreadCount =>
      notifications.where((n) => n['is_read'] == false).length;

  // ── Fetch
  Future<void> fetchNotifications() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      notifications = await _service.getNotifications();
    } catch (e) {
      errorMessage = "فشل تحميل الإشعارات";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── Mark one as read
  Future<void> markAsRead(int id) async {
    final index = notifications.indexWhere((n) => n['id'] == id);
    if (index == -1 || notifications[index]['is_read'] == true) return;

    // optimistic update
    notifications[index]['is_read'] = true;
    notifyListeners();

    try {
      await _service.markAsRead(id);
    } catch (_) {
      // roll back if API fails
      notifications[index]['is_read'] = false;
      notifyListeners();
    }
  }

  // ── Mark all as read
  Future<void> markAllAsRead() async {
    // optimistic update
    for (var n in notifications) {
      n['is_read'] = true;
    }
    notifyListeners();

    try {
      await _service.markAllAsRead();
    } catch (_) {
      // roll back
      await fetchNotifications();
    }
  }
}
