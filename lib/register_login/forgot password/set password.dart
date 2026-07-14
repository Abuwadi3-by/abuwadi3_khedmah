import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/button%20form.dart';
import 'package:graduation_project/components/text%20form%20field.dart';
import 'package:graduation_project/components/text%20form.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => Setpassword();
}

class Setpassword extends State<NewPassword> {
  final TextEditingController newpassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shadowColor: Colors.black,
        toolbarHeight: 60,
        centerTitle: true,
        backgroundColor: Colors.blue[400],
        title: TextForm(
          text: "كلمة السر الجديدة",
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
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          Gap(100),
          TextForm(
            text: "ادخل كلمة السر الجديدة",
            size: 30,
            align: TextAlign.center,
          ),
          Gap(10),
          CustomTextForm(hint: "*******", myController: newpassword),
          Gap(150),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ButtonForm(
              onPressed: () {},
              title: "حفظ",
              borderradius: BorderRadius.circular(15),
            ),
          ),
        ],
      ),
    );
  }
}
