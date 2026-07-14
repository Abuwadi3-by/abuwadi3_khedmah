import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/button%20form.dart';
import 'package:graduation_project/components/image.dart';
import 'package:graduation_project/components/text%20form.dart';

class CreateOrLogin extends StatelessWidget {
  const CreateOrLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: ListView(
        children: [
          Column(
            children: [
              Gap(80),
              Insert_Image(
                image: "images/khedma 3.png",
                height: 210,
                width: 210,
              ),
              Gap(70),
              Container(
                padding: EdgeInsets.all(15),
                width: 370,
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    TextForm(
                      text: "سجل دخول او انشأ حساباً جديداً",
                      size: 32,
                      weight: FontWeight.w600,
                      color: const Color.fromARGB(255, 59, 115, 160),
                      align: TextAlign.center,
                    ),
                    Gap(25),
                    ButtonForm(
                      padding: EdgeInsets.symmetric(horizontal: 110),
                      borderradius: BorderRadiusGeometry.circular(20),
                      title: "تسجيل الدخول",
                      onPressed: () {
                        Navigator.of(context).pushNamed("registerlogin");
                      },
                    ),
                    Gap(25),
                    ButtonForm(
                      padding: EdgeInsets.symmetric(horizontal: 115),
                      borderradius: BorderRadiusGeometry.circular(20),
                      onPressed: () {
                        Navigator.of(context).pushNamed("registeraccount");
                      },
                      title: "انشاء حساب",
                    ),
                    Gap(30),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey[600])),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: TextForm(
                            text: "الدخول كزائر",
                            color: Colors.grey[700],
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey[600])),
                      ],
                    ),
                    Gap(10),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed("categories");
                      },
                      child: TextForm(
                        text: "زيارة التطبيق",
                        size: 35,
                        weight: FontWeight.bold,
                        color: const Color.fromARGB(255, 59, 115, 160),
                        align: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
