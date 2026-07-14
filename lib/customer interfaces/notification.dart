import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/app_states.dart';
import 'package:graduation_project/components/text%20form.dart';
import 'package:graduation_project/providers/notifications_provider.dart';
import 'package:provider/provider.dart';

class Notificationpage extends StatefulWidget {
  const Notificationpage({super.key});

  @override
  State<Notificationpage> createState() => _NotificationpageState();
}

class _NotificationpageState extends State<Notificationpage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<NotificationsProvider>().fetchNotifications(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationsProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: TextForm(
          text: "الاشعارات",
          size: 30,
          weight: FontWeight.bold,
          color: Colors.blue[900],
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.all(15),
            iconSize: 28,
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_forward_outlined),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF64B5F6), Color(0xFF1976D2)],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF1976D2).withOpacity(0.4),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),

        child: ElevatedButton.icon(
          onPressed: () {
            if (provider.unreadCount > 0)
              context.read<NotificationsProvider>().markAllAsRead();
          },
          icon: Icon(Icons.local_offer_rounded, color: Colors.white),
          label: TextForm(
            text: "قراءة الكل",
            size: 20,
            color: Colors.white,
            weight: FontWeight.bold,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Colors.transparent, //   جعل الزر شفافاً ليظهر التدرج خلفه
            shadowColor: Colors
                .transparent, // إخفاء ظل الزر الافتراضي لأننا استخدمنا ظل الـ Container
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),

      body: provider.isLoading
          ? AppStates.buildLoadingState()
          : provider.errorMessage != null
          ? AppStates.buildErrorState(
              provider.errorMessage!,
              onRetry: () =>
                  context.read<NotificationsProvider>().fetchNotifications(),
            )
          : provider.notifications.isEmpty
          ? AppStates.buildEmptyState(
              "لا توجد إشعارات حالياً",
              icon: Icons.notifications_off_outlined,
            )
          : Column(
              children: [
                // عدد الرسائل الغير مقروئة
                if (provider.unreadCount > 0)
                  Container(
                    width: double.infinity,
                    color: Color(0xFF1976D2).withOpacity(0.08),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "${provider.unreadCount} إشعارات غير مقروءة",
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),

                // قائمة الاشعارات
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 30),
                    itemCount: provider.notifications.length,
                    itemBuilder: (context, index) =>
                        buildCard(provider.notifications[index]),
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildCard(Map<String, dynamic> notification) {
    final bool isRead = notification['is_read'] == true;
    final Color color = Color(0xFF1976D2);

    return GestureDetector(
      // عند الضغط على الطلب يصبح مقروءاً
      onTap: () =>
          context.read<NotificationsProvider>().markAsRead(notification['id']),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : Colors.blueGrey[100],
          borderRadius: BorderRadius.circular(16),
          border: isRead
              ? null
              : Border.all(color: color.withOpacity(0.25), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF1976D2).withOpacity(0.07),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatDate(notification['date']),
                    style: TextStyle(color: Colors.grey[600], fontSize: 11),
                  ),
                  const Gap(4),
                  Text(
                    _formatTime(notification['date']),
                    style: TextStyle(color: Colors.grey[500], fontSize: 11),
                  ),
                  //
                  if (!isRead) ...[
                    Gap(8),
                    CircleAvatar(radius: 4, backgroundColor: color),
                  ],
                ],
              ),

              const Gap(12),

              // ── Right: icon + content ───────────────────────────────
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        notification['content'] ?? '',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: isRead ? Colors.grey[700] : Colors.black87,
                          fontWeight: isRead
                              ? FontWeight.normal
                              : FontWeight.w600,
                        ),
                      ),
                    ),
                    Gap(10),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: color.withOpacity(0.12),
                      child: Icon(
                        Icons.notifications_outlined,
                        color: color,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // تنسيق التاريخ
  String _formatDate(String? raw) {
    if (raw == null) return '';
    final parts = raw.split(' ');
    return parts.isNotEmpty ? parts[0] : raw;
  }

  //  تنسيق الوقت
  String _formatTime(String? raw) {
    if (raw == null) return '';
    final parts = raw.split(' ');
    return parts.length > 1 ? parts[1] : '';
  }
}
