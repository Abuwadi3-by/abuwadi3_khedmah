import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/text%20form.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blue[400],
        title: TextForm(
          text: "الدعم والمساعدة",
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
        padding: EdgeInsets.all(15),
        children: [
          Gap(20),
          CircleAvatar(
            radius: 50,
            child: Icon(Icons.headset_mic, size: 50, color: Colors.blue[900]),
          ),
          Gap(20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextForm(
                text: "مركز الدعم و المساعدة ",
                weight: FontWeight.bold,
                size: 30,
              ),
              TextForm(
                text:
                    "يسعدنا دائماً تقديم الدعم لك لضمان تجربة سلسة وخالية من المتاعب. إذا كنت تواجه أي صعوبة في استخدام التطبيق، أو واجهتك مشكلة تقنية غير متوقعة، فنحن هنا لمساعدتك فوراً",
                size: 25,
                align: TextAlign.right,
              ),
              TextForm(
                text:
                    "لإرسال الملاحظات أو الإبلاغ عن الأعطال الرجاء التواصل على الرقم التالي ",
                size: 25,
                align: TextAlign.right,
              ),
              Gap(10),
              TextForm(
                text: "0932344996",
                weight: FontWeight.bold,
                size: 30,
                color: Colors.grey[700],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
