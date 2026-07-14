import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/button%20form.dart';
import 'package:graduation_project/components/text%20form%20field.dart';
import 'package:graduation_project/components/text%20form.dart';

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => EmailVerification();
}

class EmailVerification extends State<Verification> {
  final TextEditingController emailverifi = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
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
          text: "التحقق من الايميل",
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
      body: Form(
        key: formkey,
        child: ListView(
          padding: EdgeInsets.all(15),
          children: [
            Gap(100),
            TextForm(
              text:
                  "يرجى ادخال البريد الالكتروني للتحقق من انه موجود ثم يمكنك اعادة تعيين كلمة السر",
              size: 20,
              align: TextAlign.right,
            ),
            Gap(10),
            CustomTextForm(
              hint: "user@gmail.com",
              myController: emailverifi,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "ادخل بريدك الالكتروني";
                }
                final bool emailValid = RegExp(
                  r"^[a-zA-Z0-9_%-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$",
                ).hasMatch(val);
                if (!emailValid) {
                  return "يرجى إدخال بريد إلكتروني صالح";
                }
                return null;
              },
            ),
            Gap(150),
            Center(child: CircularProgressIndicator()),
            Gap(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ButtonForm(
                onPressed: () {
                  // if (!formkey.currentState!.validate()) {
                  //   return;
                  // }
                  Navigator.pushNamed(context, "setpassword");
                },
                title: "تعيين كلمة المرور",
                borderradius: BorderRadius.circular(15),
                // color: Colors.blue[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
