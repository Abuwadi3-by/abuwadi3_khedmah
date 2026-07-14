import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/text%20form.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blue[400],
        title: TextForm(
          text: "عن التطبيق",
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
          Gap(10),
          Image.asset(
            "images/khedma_icon.png",
            fit: BoxFit.contain,
            height: 150,
          ),
          Gap(10),
          TextForm(
            text: "عن تطبيق خدمة",
            size: 30,
            weight: FontWeight.bold,
            align: TextAlign.right,
          ),
          Gap(5),
          TextForm(
            text:
                "أهلاً بكم في منصتنا، الوجهة الرقمية المبتكرة التي تجمع بين الكفاءة والراحة، وتختصر المسافات لتلبية احتياجاتكم اليومية بكل سهولة وأمان",
            size: 25,
            align: TextAlign.right,
          ),
          TextForm(
            text: ": رؤيتنا ",
            size: 30,
            weight: FontWeight.bold,
            align: TextAlign.right,
          ),
          Gap(5),
          TextForm(
            text:
                "يسعى تطبيقنا إلى بناء مجتمع خدمي متكامل، يربط بين طالبي الخدمات الباحثين عن الجودة والسرعة، وبين المهنيين المحترفين وأصحاب الخبرات المستعدين لتقديم مهاراتهم وتوسيع أعمالهم",
            size: 25,
            align: TextAlign.right,
          ),
          Gap(5),
          TextForm(
            text: " كيف نعمل ؟ ",
            size: 30,
            align: TextAlign.right,
            weight: FontWeight.bold,
          ),
          Gap(5),
          TextForm(
            text:
                "ميزتنا الأساسية هي المرونة والشفافية الكاملة؛ حيث نتيح للمستخدم إمكانية إضافة طلبه وتحديد تفاصيله بكل حرية. وفي المقابل، يستطيع المهنيون الاطلاع على هذه الطلبات وتقديم عروض أسعار تنافسية ومخصصة. وبذلك، يمتلك المستخدم القرار الكامل في اختيار العرض الأنسب له بناءً على السعر والتقييم، لتبدأ مرحلة التواصل المباشر وإتمام العمل بنجاح",
            size: 25,
            align: TextAlign.right,
          ),
          Gap(5),
          TextForm(
            text: ": قيمنا ",
            size: 30,
            weight: FontWeight.bold,
            align: TextAlign.right,
          ),
          Gap(5),
          TextForm(
            text:
                "الشفافية: نوفر بيئة عادلة تتيح للجميع فرصة الاختيار والمقارنة\n الموثوقية: نضمن توفير بيئة تواصل مباشرة وآمنة بين الطرفين\n دعم الخبرات المحلية: نساهم في تمكين المهنيين وأصحاب الحرف من الوصول إلى قاعدة عملاء أوسع وبطرق عصرية \n شكرًا لثقتكم بنا واختياركم منصتنا لتكون شريككم اليومي في إنجاز أعمالكم وتلبية تطلعاتكم",
            size: 25,
            align: TextAlign.right,
          ),
          Gap(40),
        ],
      ),
    );
  }
}
