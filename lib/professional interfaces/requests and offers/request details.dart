import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/button%20form.dart';
import 'package:graduation_project/components/text%20form.dart';
import 'package:graduation_project/providers/professional_requests_provider.dart';
import 'package:provider/provider.dart';

class RequestDetails extends StatelessWidget {
  const RequestDetails({super.key});
  @override
  Widget build(BuildContext context) {
    final order = context.watch<ProfessionalRequestsProvider>().selected;
    if (order == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF1976D2),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_forward_outlined, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        body: Center(child: TextForm(text: "لم يتم تحديد طلب")),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blue[400],
        title: TextForm(
          text: "تفاصيل الطلب ",
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              order['imageUrl'],
              width: double.infinity,
              height: 230,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 230,
                color: Colors.grey[200],
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Gap(20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // name + avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextForm(
                    text: order['name'],
                    size: 22,
                    weight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                  ),
                  Gap(10),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Color(0xFFE3F2FD),
                    child: Icon(
                      Icons.person_rounded,
                      color: Color(0xFF1976D2),
                      size: 24,
                    ),
                  ),
                ],
              ),
              Gap(10),
              // location
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextForm(
                    text: order['location'],
                    size: 17,
                    color: Colors.grey[700],
                  ),
                  Gap(5),
                  Icon(
                    Icons.location_on_outlined,
                    color: Color(0xFF1976D2),
                    size: 20,
                  ),
                  Gap(2),
                ],
              ),
              Gap(9),
              // date
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextForm(
                    text: order['date'],
                    size: 16,
                    color: Colors.grey[500],
                  ),
                  Gap(6),
                  Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                    size: 16,
                  ),
                  Gap(3),
                ],
              ),

              Gap(14),
              Divider(color: Color(0xFFE3F2FD)),
              Gap(10),

              // problem description
              TextForm(
                text: "وصف المشكلة",
                weight: FontWeight.bold,
                size: 20,
                color: Color(0xFF0D47A1),
              ),
              Gap(10),
              TextForm(
                text: order['details'],
                size: 20,
                align: TextAlign.right,
              ),
            ],
          ),

          Gap(24),
          ButtonForm(
            onPressed: () {
              Navigator.pushNamed(
                context,
                "createofferforrequest",
              ); ///////////////////////////////////////////
            },
            color: Color(0xFF1976D2),
            height: 50,
            title: "تقديم عرض",
            padding: EdgeInsets.symmetric(horizontal: 90),
            borderradius: BorderRadius.circular(15),
          ),
          Gap(20),
        ],
      ),
    );
  }
}
