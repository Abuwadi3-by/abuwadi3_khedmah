import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/button%20form.dart';
import 'package:graduation_project/components/image.dart';

class ProfessionalHomePage extends StatefulWidget {
  const ProfessionalHomePage({super.key});
  @override
  State<ProfessionalHomePage> createState() => HomePage();
}

class HomePage extends State<ProfessionalHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 5),
        backgroundColor: Colors.white,
        actions: [
          Container(
            padding: EdgeInsets.only(left: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "conversations");
              },
              icon: Icon(
                Icons.message_rounded,
                size: 25,
                color: const Color.fromARGB(255, 59, 115, 160),
              ),
            ),
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "notification");
              },
              icon: Icon(
                Icons.notifications,
                size: 25,
                color: const Color.fromARGB(255, 59, 115, 160),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "generalsetting");
            },
            icon: Icon(
              Icons.settings,
              color: const Color.fromARGB(255, 59, 115, 160),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Insert_Image(
            image: "images/khedma_home.png",
            height: 250,
            width: 250,
            color: Colors.white,
          ),
          Gap(50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ButtonForm(
              height: 70,
              onPressed: () {
                Navigator.of(context).pushNamed("customerrequests");
              },
              title: "الطلبات",
              borderradius: BorderRadius.circular(30),
            ),
          ),
          Gap(20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: ButtonForm(
              height: 70,

              onPressed: () {
                Navigator.pushNamed(context, "wallet");
              },
              title: "المحفظة",
              borderradius: BorderRadius.circular(30),
            ),
          ),
          Gap(20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: ButtonForm(
              height: 70,

              onPressed: () {
                Navigator.pushNamed(context, "offerspresented");
              },
              title: "العروض المقدمة",
              borderradius: BorderRadius.circular(30),
            ),
          ),
        ],
      ),
    );
  }
}
