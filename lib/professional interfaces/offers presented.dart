import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/app_states.dart';
import 'package:graduation_project/components/primary%20color.dart';
import 'package:graduation_project/components/text%20form.dart';
import 'package:graduation_project/providers/offers_presented_provider.dart';
import 'package:provider/provider.dart';

class OffersPresented extends StatefulWidget {
  const OffersPresented({super.key});

  @override
  State<OffersPresented> createState() => offerspresented();
}

// ignore: camel_case_types
class offerspresented extends State<OffersPresented> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<OffersPresentedProvider>().fetchSubmittedOffers(),
    );
  }

  // ── Status helpers ───────────────────────────────────────────────────────────
  Color statusColor(String status) {
    switch (status) {
      case "مقبول":
        return Color(0xFF2E7D32);
      case "مرفوض":
        return Colors.red[700]!;
      case "قيد الانتظار":
        return Color(0xFFF57F17);
      default:
        return Colors.grey;
    }
  }

  IconData statusIcon(String status) {
    switch (status) {
      case "مقبول":
        return Icons.check_circle_outline_rounded;
      case "مرفوض":
        return Icons.cancel_outlined;
      case "قيد الانتظار":
        return Icons.hourglass_top_rounded;
      default:
        return Icons.info_outline;
    }
  }

  // ── Offer card --------------------------------------------
  Widget buildOfferCard(Map<String, dynamic> offer) {
    final String status = offer['status'] ?? 'قيد الانتظار';
    final Color statuscolor = statusColor(status);
    final IconData statusicon = statusIcon(status);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // ── Top: status banner ───────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: statuscolor.withOpacity(0.10),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // date
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: Colors.grey,
                    ),
                    Gap(4),
                    TextForm(text: offer['date'], size: 16, color: Colors.grey),
                  ],
                ),
                // status badge
                Row(
                  children: [
                    TextForm(
                      text: status,
                      size: 16,
                      weight: FontWeight.bold,
                      color: statuscolor,
                    ),
                    Gap(5),
                    Icon(statusicon, color: statuscolor, size: 18),
                  ],
                ),
              ],
            ),
          ),

          // ── Middle: content ──────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // request title
                TextForm(
                  text: " الطلب : ${offer['requestTitle']}",
                  size: 18,
                  weight: FontWeight.bold,
                  color: Color(0xFF0D47A1),
                  align: TextAlign.right,
                ),

                Gap(8),

                // client name + location
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextForm(
                      text: offer['location'],
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    Gap(6),
                    Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFF1976D2),
                      size: 15,
                    ),
                    Gap(10),
                    TextForm(
                      text: offer['clientName'],
                      size: 16,
                      weight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                    Gap(5),
                    Icon(
                      Icons.person_outline_rounded,
                      color: Color(0xFF1976D2),
                      size: 15,
                    ),
                  ],
                ),

                // Gap(10),
                Divider(color: Color(0xFFE3F2FD)),
                // Gap(5),
                TextForm(
                  text: "محتوى العرض",
                  size: 20,
                  weight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
                Gap(8),
                // offer details
                TextForm(
                  text: offer['details'],
                  size: 16,
                  align: TextAlign.right,
                  color: Colors.grey[600],
                ),

                Gap(12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OffersPresentedProvider>();
    return Scaffold(
      backgroundColor: AppColor.backgroundcolor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blue[400],
        title: TextForm(
          text: "العروض المقدمة سابقاً",
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
              onRetry: () => context
                  .read<OffersPresentedProvider>()
                  .fetchSubmittedOffers(),
            )
          : provider.offers.isEmpty
          ? AppStates.buildEmptyState(
              "لم تقدم أي عروض بعد",
              icon: Icons.description_outlined,
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
              itemCount: provider.offers.length,
              itemBuilder: (context, index) =>
                  buildOfferCard(provider.offers[index]),
            ),
    );
  }
}
