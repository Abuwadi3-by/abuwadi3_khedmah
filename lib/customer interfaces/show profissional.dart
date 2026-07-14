import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/app_states.dart';
import 'package:graduation_project/components/text%20form.dart';
import 'package:graduation_project/providers/professional_provider.dart';
import 'package:provider/provider.dart';

class ShowProfessionals extends StatefulWidget {
  final String category;
  const ShowProfessionals({super.key, required this.category});

  @override
  State<ShowProfessionals> createState() => _ShowProfessionalsState();
}

class _ShowProfessionalsState extends State<ShowProfessionals> {
  @override
  void initState() {
    super.initState();
    // fetch professionals for THIS category when page opens
    Future.microtask(
      () => context.read<ProfessionalsProvider>().fetchProfessionals(
        widget.category,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfessionalsProvider>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue[400],
        automaticallyImplyLeading: false,
        toolbarHeight: 60,
        shadowColor: Colors.black,

        title: TextForm(
          text: "المهنيين",
          size: 43,
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
                  .read<ProfessionalsProvider>()
                  .fetchProfessionals(widget.category),
            )
          : provider.professionals.isEmpty
          ? AppStates.buildEmptyState(
              "لا يوجد مختصون في هذه الفئة حالياً",
              icon: Icons.person_search_outlined,
            )
          : ListView.builder(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 30),
              itemCount: provider.professionals.length,
              itemBuilder: (context, index) =>
                  buildProfessionalCard(provider.professionals[index]),
            ),
    );
  }

  Widget buildProfessionalCard(Map<String, dynamic> professional) {
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1976D2).withOpacity(0.10),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextForm(
                      text: professional['name'],
                      size: 20,
                      color: Color(0xFF0D47A1),
                      weight: FontWeight.bold,
                    ),
                    TextForm(
                      text: professional['description'],
                      size: 17,
                      align: TextAlign.right,
                    ),
                    Gap(10),
                    Row(
                      children: [
                        Spacer(),
                        TextForm(
                          text: "${professional['rate']}",
                          weight: FontWeight.bold,
                          size: 15,
                        ),
                        Gap(3),
                        Icon(
                          Icons.star_rounded,
                          color: Colors.orange,
                          size: 15,
                        ),
                        Gap(10),
                        TextForm(text: professional['experience'], size: 15),
                      ],
                    ),
                  ],
                ),
              ),
              Gap(10),
              CircleAvatar(
                radius: 22,
                backgroundColor: Color(0xFFE3F2FD),
                child: Icon(
                  Icons.person_rounded,
                  color: Color(0xFF1976D2),
                  size: 20,
                ),
              ),
            ],
          ),
          Gap(6),
        ],
      ),
    );
  }
}
