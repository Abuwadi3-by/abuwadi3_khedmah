import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/communication/chat_page.dart';
import 'package:graduation_project/components/app_states.dart';
import 'package:graduation_project/components/primary%20color.dart';
import 'package:graduation_project/components/text%20form.dart';
import 'package:graduation_project/providers/coversation_provider.dart';
import 'package:graduation_project/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class Conversations extends StatefulWidget {
  @override
  State<Conversations> createState() => Conversation();
}

class Conversation extends State<Conversations> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<ConversationsProvider>().fetchConversations(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ConversationsProvider>();
    final ispro = context.watch<ProfileProvider>().isProfessional;
    return Scaffold(
      backgroundColor: AppColor.backgroundcolor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blue[400],
        title: TextForm(
          text: "المحادثات",
          size: 30,
          weight: FontWeight.bold,
          color: Colors.blue[900],
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.all(15),
            iconSize: 30,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_forward_outlined),
          ),
        ],
      ),
      body: provider.isLoading
          ? AppStates.buildLoadingState()
          : provider.errorMessage != null
          ? AppStates.buildErrorState(
              provider.errorMessage!,
              onRetry: () {
                context.read<ConversationsProvider>().fetchConversations();
              },
            )
          : provider.conversations.isEmpty
          ? AppStates.buildEmptyState(
              ispro
                  ? "لا توجد محادثات مع عملاء بعد"
                  : "لا توجد محادثات مع مهنيين بعد",
              icon: Icons.chat_bubble_outline_outlined,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: double.infinity,
                  color: Color(0xFF1976D2).withOpacity(0.08),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextForm(
                    text: ispro
                        ? "محادثاتك مع المهنيين"
                        : "محادثاتك مع العملاء",
                    align: TextAlign.right,
                    color: Color(0xFF1976D2),
                    size: 16,
                    weight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 25),
                    itemCount: provider.conversations.length,
                    itemBuilder: (context, index) =>
                        buildConversationItem(provider.conversations[index]),
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildConversationItem(Map<String, dynamic> conversation) {
    final int unread = conversation['unread_count'] ?? 0;
    final bool hasUnread = unread > 0;

    return GestureDetector(
      onTap: () {
        context.read<ConversationsProvider>().markConversationRead(
          conversation['id'],
        );

        // open chat
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(conversation: conversation),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black54.withOpacity(0.08),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Row(
            children: [
              //  "الوقت وتحته علامة غير مقروءة "عدد الرسائل
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    formatTime(conversation['last_message_at']),
                    style: TextStyle(color: Colors.grey[500], fontSize: 11),
                  ),
                  Gap(6),
                  if (hasUnread)
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Color(0xFF1976D2),
                      child: TextForm(
                        text: "$unread",
                        size: 15,
                        color: Colors.white,
                        weight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              Gap(12),
              // الصورة و الاسم و آخر رسالة ------------------------
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextForm(
                            text: conversation['other_person_name'] ?? '',
                            align: TextAlign.right,
                            size: 20,
                            weight: hasUnread
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: Color(0xFF0D47A1),
                          ),
                          Gap(5),
                          // آخر رسالة
                          TextForm(
                            text: conversation['last_message'] ?? '',
                            align: TextAlign.right,
                            size: 17,
                            weight: hasUnread
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: hasUnread
                                ? Colors.black87
                                : Colors.grey[600],
                          ),
                        ],
                      ),
                    ),
                    Gap(10),
                    // avatar
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Color(0xFFE3F2FD),
                      child: Icon(
                        Icons.person_rounded,
                        color: Color(0xFF1976D2),
                        size: 28,
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

  String formatTime(String? raw) {
    if (raw == null) return '';
    final parts = raw.split(' ');
    return parts.length > 1 ? parts[1] : raw;
  }
}
