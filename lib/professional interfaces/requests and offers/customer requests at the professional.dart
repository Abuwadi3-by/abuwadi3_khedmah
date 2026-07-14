import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/app_states.dart';
import 'package:graduation_project/components/button%20form.dart';
import 'package:graduation_project/components/primary%20color.dart';
import 'package:graduation_project/components/text%20form.dart';
import 'package:graduation_project/providers/professional_requests_provider.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types الطلبات الموجودة لدى المهني
class Requests_at_the_Professional extends StatefulWidget {
  const Requests_at_the_Professional({super.key});
  @override
  State<Requests_at_the_Professional> createState() => Requests();
}

// ignore: camel_case_types
class Requests extends State<Requests_at_the_Professional> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => context.read<ProfessionalRequestsProvider>().fetchRequests(),
    );
  }

  Widget buildRequestCard(Map<String, dynamic> request) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              request['imageUrl'],
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stacktrack) => Container(
                height: 160,
                color: Color(0xFFE3F2FD),
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.grey,
                  size: 48,
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // name + date row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // date
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 13,
                          color: Colors.grey,
                        ),
                        Gap(4),
                        TextForm(
                          text: request['date'],
                          size: 15,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    // name + avatar
                    Row(
                      children: [
                        TextForm(
                          text: request['name'],
                          size: 20,
                          weight: FontWeight.bold,
                          color: Color(0xFF0D47A1),
                        ),
                        Gap(8),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(0xFFE3F2FD),
                          child: Icon(
                            Icons.person_rounded,
                            color: Color(0xFF1976D2),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Gap(8),
                Divider(color: Color(0xFFE3F2FD)),
                Gap(6),

                // details
                TextForm(
                  text: request['details'],
                  align: TextAlign.right,
                  size: 20,
                ),

                Gap(8),

                // location
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextForm(
                      text: request['location'],
                      size: 17,
                      color: Colors.grey[700],
                    ),
                    Gap(4),
                    Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFF1976D2),
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Bottom: details button ─────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: ButtonForm(
              onPressed: () {
                context.read<ProfessionalRequestsProvider>().selectRequest(
                  request,
                );
                Navigator.pushNamed(context, "requestdetails");
              },
              color: Color(0xFF1976D2),
              height: 44,
              title: "عرض التفاصيل",
              padding: EdgeInsets.symmetric(horizontal: 100),
              borderradius: BorderRadius.circular(15),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfessionalRequestsProvider>();
    return Scaffold(
      backgroundColor: AppColor.backgroundcolor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blue[400],
        title: TextForm(
          text: "الطلبات",
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
              onRetry: () =>
                  context.read<ProfessionalRequestsProvider>().fetchRequests(),
            )
          : provider.requests.isEmpty
          ? AppStates.buildEmptyState(
              "لا توجد طلبات حالياً",
              icon: Icons.inbox_outlined,
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
              itemCount: provider.requests.length,
              itemBuilder: (context, index) =>
                  buildRequestCard(provider.requests[index]),
            ),
    );
  }
}
