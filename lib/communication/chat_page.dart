import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/communication/complaint.dart';
import 'package:graduation_project/communication/rating_page.dart';
import 'package:graduation_project/components/text%20form.dart';
import 'package:graduation_project/providers/chat_provider.dart';
import 'package:graduation_project/providers/coversation_provider.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final Map<String, dynamic> conversation;
  const ChatPage({super.key, required this.conversation});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          context.read<ChatProvider>().fetchMessages(widget.conversation['id']),
    );
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();

    super.dispose();
  }

  // زر للنزول لآخر رسالة ----------------------------
  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ارسال رسالة ---------------------------
  Future<void> send() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    _input.clear();

    await context.read<ChatProvider>().sendMessage(
      conversationId: widget.conversation['id'],
      content: text,
    );

    // تحديث آخر رسالة في المحادثة -------------------
    if (mounted) {
      context.read<ConversationsProvider>().updateLastMessage(
        widget.conversation['id'],
        text,
      );
    }

    scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatProvider>();
    final String otherName = widget.conversation['other_person_name'] ?? '';

    // scroll when messages update
    if (!provider.isLoading) scrollToBottom();

    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF1976D2),
        actions: [
          Gap(5),
          SizedBox(
            width: 75,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Complaint(
                      reportedUserId: widget.conversation['other_person_id'],
                      reportedUserName:
                          widget.conversation['other_person_name'] ?? '',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(17),
                ),
              ),
              child: TextForm(
                text: "شكوى",
                size: 16,
                weight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Gap(5),
          SizedBox(
            width: 75,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RatingPage(
                      professionalId: widget.conversation['other_person_id'],
                      professionalName:
                          widget.conversation['other_person_name'] ?? '',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(17),
                ),
              ),
              child: TextForm(
                text: "تقييم",
                size: 16,
                weight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Spacer(),
          TextForm(
            text: otherName,
            size: 22,
            weight: FontWeight.bold,
            color: Colors.white,
            align: TextAlign.right,
          ),
          Gap(8),
          CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFFBBDEFB),
            child: Icon(
              Icons.person_rounded,
              color: Color(0xFF1976D2),
              size: 22,
            ),
          ),
          IconButton(
            iconSize: 26,
            onPressed: () {
              context.read<ChatProvider>().clear();

              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_forward_rounded, color: Colors.white),
          ),
        ],
      ),

      body: Column(
        children: [
          // قائمة الرسائل --------------------------------
          Expanded(
            child: provider.isLoading
                ? Center(
                    child: CircularProgressIndicator(color: Color(0xFF1976D2)),
                  )
                : provider.messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 60,
                          color: Colors.grey[300],
                        ),
                        Gap(12),
                        TextForm(
                          text: "ابدأ محادثة الان",
                          size: 21,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scroll,
                    padding: EdgeInsets.fromLTRB(12, 16, 12, 0),
                    itemCount: provider.messages.length,
                    itemBuilder: (context, index) {
                      final msg = provider.messages[index];
                      // group date separator
                      final showDate =
                          index == 0 ||
                          formatDate(msg['created_at']) !=
                              formatDate(
                                provider.messages[index - 1]['created_at'],
                              );
                      return Column(
                        children: [
                          if (showDate) buildDateSeparator(msg['created_at']),
                          buildBubble(msg),
                        ],
                      );
                    },
                  ),
          ),

          if (provider.errorMessage != null)
            Container(
              color: Colors.red[50],
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextForm(
                text: provider.errorMessage!,
                align: TextAlign.right,
                color: Colors.red,
                size: 17,
              ),
            ),
          // حقل الادخال -----------------------
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(8, 8, 8, 12),
            child: Row(
              children: [
                // send button
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFF1976D2),
                  child: IconButton(
                    onPressed: provider.isSending ? null : send,
                    icon: provider.isSending
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                  ),
                ),

                Gap(8),

                // text field
                Expanded(
                  child: TextField(
                    controller: _input,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    maxLines: 3,
                    minLines: 1,
                    decoration: InputDecoration(
                      hintText: "اكتب رسالة...",
                      hintTextDirection: TextDirection.rtl,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => send(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Message bubble ──────────────────────────────────────────────────────────
  Widget buildBubble(Map<String, dynamic> msg) {
    final bool isMine = msg['is_mine'] == true;
    final bool isPending = msg['pending'] == true;
    final bool isFailed = msg['failed'] == true;

    return Align(
      // رسالتي على اليمين ورسالة الآخر على اليسار
      alignment: isMine ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMine ? Color(0xFF1976D2) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(isMine ? 4 : 18),
            bottomRight: Radius.circular(isMine ? 18 : 4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isMine
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            // محتوى الرسالة --------------------
            Text(
              msg['content'] ?? '',
              textAlign: isMine ? TextAlign.left : TextAlign.right,
              style: TextStyle(
                fontSize: 15,
                height: 1.4,
                color: isMine ? Colors.white : Colors.black87,
              ),
            ),
            Gap(4),
            // time + status icon
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // failed icon
                if (isFailed)
                  Icon(Icons.error_outline, color: Colors.red, size: 14),

                // pending clock
                if (isPending && !isFailed)
                  Icon(
                    Icons.access_time_rounded,
                    color: Colors.white.withOpacity(0.7),
                    size: 12,
                  ),
                Gap(4),
                TextForm(
                  text: formatTime(msg['created_at']),
                  size: 14,
                  color: isMine
                      ? Colors.white.withOpacity(0.75)
                      : Colors.black54,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDateSeparator(String? raw) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: Divider()),
          Gap(8),
          TextForm(
            text: formatDate(raw),
            size: 17,
            weight: FontWeight.w500,
            color: Colors.grey[500],
          ),
          Gap(8),
          Expanded(child: Divider()),
        ],
      ),
    );
  }

  String formatDate(String? raw) {
    if (raw == null) return '';
    return raw.split(' ').first;
  }

  String formatTime(String? raw) {
    if (raw == null) return '';
    final parts = raw.split(' ');
    return parts.length > 1 ? parts[1] : raw;
  }
}
