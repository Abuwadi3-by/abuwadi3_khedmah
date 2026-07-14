import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/app_states.dart';
import 'package:graduation_project/components/primary%20color.dart';
import 'package:graduation_project/components/text%20form.dart';
import 'package:graduation_project/customer%20interfaces/request%20and%20offer/offers.dart';
import 'package:graduation_project/providers/requests_provider.dart';
import 'package:provider/provider.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => Request();
}

class Request extends State<Requests> {
  @override
  void initState() {
    super.initState();
    // fetch once when the page opens
    Future.microtask(() => context.read<RequestsProvider>().fetchRequests());
  }

  // static const Color _navy = Color(0xFF0D47A1);
  // static const Color _blue = Color(0xFF1976D2);
  // static const Color _skyLight = Color(0xFFE3F2FD);
  // static const Color _accent = Color(0xFF00B0FF);
  // static const Color _green = Color(0xFF2E7D32);
  // static const Color _cardShadow = Color(0x1A1976D2);

  Widget buildRequestLayout(List<Map<String, dynamic>> requests) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 100),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return Container(
          margin: EdgeInsets.only(bottom: 13),
          decoration: BoxDecoration(
            color: Color(0xFF1976D2),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextForm(
                          text: "${request['offers_count'] ?? 0} عروض",
                          color: Colors.white,
                          size: 15,
                          weight: FontWeight.bold,
                        ),
                      ),
                      Gap(20),
                      SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OffersScreen(request: request),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.withOpacity(0.7),
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shadowColor: const Color(0x331976D2),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: TextForm(
                            text: "العروض ",
                            size: 16,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.local_offer_rounded,
                          color: Colors.white70,
                          size: 28,
                        ),
                        Gap(12),
                        TextForm(
                          text: request['title'] ?? '',
                          align: TextAlign.right,
                          size: 22,
                          weight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        Gap(8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextForm(
                              text: request['date'] ?? '',
                              size: 16,
                              color: Colors.white70,
                            ),
                            Gap(6),
                            Icon(
                              Icons.calendar_today,
                              color: Colors.white70,
                              size: 14,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RequestsProvider>();
    return Scaffold(
      backgroundColor: AppColor.backgroundcolor,
      // const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: Color(0xFF1976D2),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "الطلبات والعروض",
          style: TextStyle(
            color: Colors.indigo[800],
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            iconSize: 30,
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_forward_rounded),
          ),
        ],
      ),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : provider.errorMessage != null
          ? AppStates.buildErrorState(provider.errorMessage!, onRetry: () {})
          : provider.requests.isEmpty
          ? AppStates.buildEmptyState("لا توجد طلبات حتى الآن")
          : buildRequestLayout(provider.requests),
    );
  }
}
