import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/custom%20card.dart';
import 'package:graduation_project/components/text%20form.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blue[400],
        title: TextForm(
          text: "الإعدادات",
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
        padding: EdgeInsets.all(12),
        children: [
          CustomCard(
            onTap: () {
              Navigator.pushNamed(context, "profile");
            },
            height: 25,
            title: "الملف الشخصي",
            trailing: CircleAvatar(
              backgroundColor: Colors.blue[50],
              radius: 20,
              child: Icon(Icons.person, color: Colors.blue[900]),
            ),
            leading: Icon(Icons.arrow_back_ios_new),
          ),
          Gap(7),
          CustomCard(
            onTap: () {
              Navigator.pushNamed(context, "notification");
            },
            height: 25,
            title: "الاشعارات",

            trailing: CircleAvatar(
              backgroundColor: Colors.blue[50],
              radius: 20,
              child: Icon(Icons.notifications, color: Colors.blue[900]),
            ),
            leading: Icon(Icons.arrow_back_ios_new),
          ),
          Gap(7),
          CustomCard(
            title: "سجل المحادثات",
            height: 25,
            leading: Icon(Icons.arrow_back_ios_new),

            onTap: () {
              Navigator.pushNamed(context, "conversations");
            },
            trailing: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue[50],
              child: Icon(Icons.message, color: Colors.blue[900]),
            ),
          ),
          Gap(7),
          CustomCard(
            onTap: () {
              Navigator.pushNamed(context, "support");
            },
            height: 25,
            title: "الدعم والمساعدة",
            trailing: CircleAvatar(
              backgroundColor: Colors.blue[50],
              radius: 20,
              child: Icon(Icons.headset_mic, color: Colors.blue[900]),
            ),
            leading: Icon(Icons.arrow_back_ios_new),
          ),
          Gap(7),
          CustomCard(
            onTap: () {
              Navigator.pushNamed(context, "about");
            },
            height: 25,
            title: "عن التطبيق",
            trailing: CircleAvatar(
              backgroundColor: Colors.blue[50],
              radius: 20,
              child: Icon(Icons.info, color: Colors.blue[900]),
            ),
            leading: Icon(Icons.arrow_back_ios_new),
          ),
          Gap(7),
          CustomCard(
            onTap: () {},
            height: 25,
            title: "تسجيل الخروج",
            trailing: CircleAvatar(
              backgroundColor: Colors.red[50],
              radius: 20,
              child: Icon(Icons.logout_outlined, color: Colors.red[300]),
            ),
            leading: Icon(Icons.arrow_back_ios_new),
          ),
          Gap(7),
        ],
      ),
    );
  }
}
