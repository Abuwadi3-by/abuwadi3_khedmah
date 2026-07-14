import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/button%20form.dart';
import 'package:graduation_project/components/image.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePage();
}

class _CustomerHomePage extends State<CustomerHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //const Color(0xFFE3F2FD)
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
            height: 230,
            width: 230,
            color: Colors.white,
          ),
          Gap(40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: ButtonForm(
              onPressed: () {
                Navigator.of(context).pushNamed("service_request");
              },
              title: "اطلب خدمة",
              borderradius: BorderRadius.circular(30),
            ),
          ),
          Gap(20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: ButtonForm(
              onPressed: () {
                Navigator.pushNamed(context, "requests");
              },
              title: "الطلب والعروض",
              borderradius: BorderRadius.circular(30),
            ),
          ),
          Gap(25),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: ButtonForm(
              onPressed: () {
                Navigator.pushNamed(context, "categories");
              },
              title: "استعراض المهنيين",
              borderradius: BorderRadius.circular(30),
            ),
          ),
        ],
      ),
    );
  }
}
