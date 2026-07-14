// lib/pages/rating_page.dart

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/text%20form.dart';
import 'package:graduation_project/providers/rating_provider.dart';
import 'package:graduation_project/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class RatingPage extends StatefulWidget {
  final int professionalId;
  final String professionalName;

  const RatingPage({
    super.key,
    required this.professionalId,
    required this.professionalName,
  });

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<RatingProvider>().reset());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color ratingColor(int value) {
    if (value <= 3) return Colors.red;
    if (value <= 6) return Colors.orange;
    if (value <= 8) return const Color(0xFF1976D2);
    return const Color(0xFF2E7D32);
  }

  String ratingLabel(int value) {
    if (value == 0) return "لم تختر بعد";
    if (value <= 3) return "ضعيف";
    if (value <= 5) return "مقبول";
    if (value <= 7) return "جيد";
    if (value <= 9) return "جيد جداً";
    return "ممتاز";
  }

  Future<void> submit() async {
    final newAverage = await context.read<RatingProvider>().submitRating(
      professionalId: widget.professionalId,
    );

    if (!mounted) return;

    if (newAverage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "تم إرسال تقييمك بنجاح. شكراً لك!",
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 14),
          ),
          backgroundColor: const Color(0xFF2E7D32),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(12),
          duration: Duration(seconds: 2),
        ),
      );
      await Future.delayed(Duration(seconds: 2));
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isProfessional = context.watch<ProfileProvider>().isProfessional;
    if (isProfessional) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFF1976D2),
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_forward_rounded, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        body: const Center(
          child: Text(
            "هذه الصفحة متاحة للمستخدمين فقط",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    final provider = context.watch<RatingProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: 60,
        backgroundColor: Colors.blue[400],
        title: TextForm(
          text: "تقييم المهني",
          size: 34,
          weight: FontWeight.bold,
          color: Colors.blue[900],
        ),
        actions: [
          IconButton(
            iconSize: 26,
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_forward_rounded),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Gap(16),

            // ── Professional info card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF1976D2),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextForm(
                        text: widget.professionalName,
                        size: 20,
                        weight: FontWeight.bold,
                        color: const Color(0xFF0D47A1),
                      ),
                      const Gap(4),
                      TextForm(
                        text: "قيّم تجربتك مع هذا المهني",
                        size: 14,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  const Gap(14),
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFFE3F2FD),
                    child: Icon(
                      Icons.person_rounded,
                      color: Color(0xFF1976D2),
                      size: 34,
                    ),
                  ),
                ],
              ),
            ),

            const Gap(20),

            // ── Rating card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1976D2).withOpacity(0.09),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextForm(
                    text: "اختر تقييمك من 1 إلى 10",
                    size: 16,
                    weight: FontWeight.bold,
                    color: const Color(0xFF0D47A1),
                  ),

                  const Gap(20),

                  // ── 10 rating circles
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(10, (i) {
                      final int value = i + 1;
                      final bool isSelected = provider.selectedRating == value;
                      final Color activeColor = ratingColor(value);

                      return GestureDetector(
                        onTap: () =>
                            context.read<RatingProvider>().selectRating(value),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isSelected ? activeColor : Colors.grey[100],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? activeColor
                                  : Colors.grey[300]!,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "$value",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  const Gap(16),

                  // ── Selected value label
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: provider.selectedRating == 0
                        ? Text(
                            "لم تختر بعد",
                            key: const ValueKey('none'),
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 15,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            key: ValueKey(provider.selectedRating),
                            children: [
                              Text(
                                ratingLabel(provider.selectedRating),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ratingColor(provider.selectedRating),
                                ),
                              ),
                              const Gap(8),
                              Text(
                                "${provider.selectedRating} / 10",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ratingColor(provider.selectedRating),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),

            const Gap(20),

            // ── Submit button ──────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: provider.isSubmitting ? null : submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: provider.isSubmitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "إرسال التقييم",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const Gap(30),
          ],
        ),
      ),
    );
  }
}
