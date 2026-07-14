import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/button%20form.dart';
import 'package:graduation_project/components/text%20form.dart';

class WelcomPage extends StatelessWidget {
  const WelcomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              Image.asset("images/logo first page.png"),
              Gap(20),
              TextForm(
                text: "أهلاً بك في تطبيق خدمة",
                align: TextAlign.center,
                size: 65,
                weight: FontWeight.bold,
                color: const Color.fromARGB(255, 59, 115, 160),
              ),
              Gap(15),
              Container(
                padding: EdgeInsets.all(20),
                child: TextForm(
                  text:
                      "منصتك المتكاملة لطلب الخدمات المنزلية \nوالمهنية بكل سهولة وأمان \n نحن نربطك بأفضل المهنيين في منطقتك \nلضمان جودة العمل و سرعة التنفيذ ",
                  size: 28,
                  align: TextAlign.center,
                  weight: FontWeight.w600,
                  color: const Color.fromARGB(255, 59, 115, 160),
                ),
              ),
              Gap(40),
              ButtonForm(
                padding: EdgeInsets.symmetric(horizontal: 110),
                borderradius: BorderRadiusGeometry.circular(20),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed("createorlogin");
                },
                title: "ابدأ الآن ",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
