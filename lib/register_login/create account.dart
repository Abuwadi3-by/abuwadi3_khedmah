import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/button%20form.dart';
import 'package:graduation_project/components/image.dart';
import 'package:graduation_project/components/text%20form%20field.dart';
import 'package:graduation_project/components/text%20form.dart';
import 'package:graduation_project/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class RegisterAccount extends StatefulWidget {
  const RegisterAccount({super.key});

  @override
  State<RegisterAccount> createState() => Register();
}

class Register extends State<RegisterAccount> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  // key
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  Future<void> register() async {
    // ازالة الاخطاء اذا المستخدم حاول وفشل سابقا
    context.read<AuthProvider>().clearError();

    // if (!formkey.currentState!.validate()) return;//////////////////////////// الغاء التعليق عند الربط

    final success = await context.read<AuthProvider>().register(
      name: name.text,
      email: email.text.trim(),
      password: password.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushNamed("registerinformation");
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD),
      body: Form(
        key: formkey,
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 300, top: 20),

                  child: IconButton(
                    iconSize: 30,
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushReplacementNamed("createorlogin");
                    },
                    icon: Icon(Icons.arrow_forward),
                  ),
                ),
                Insert_Image(
                  image: "images/khedma 3.png",
                  height: 210,
                  width: 210,
                ),
                Gap(40),
                Container(
                  padding: EdgeInsets.all(15),
                  width: 370,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "اسم المستخدم  ",
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 59, 115, 160),
                        ),
                      ),
                      Gap(10),
                      CustomTextForm(
                        hint: "اسم المستخدم",
                        myController: name,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "يرجى ادخال اسم المستخدم";
                          }
                          if (val.length < 4) {
                            return "يجب ان يكون الاسم اكبر من 4 احرف";
                          }
                          return null;
                        },
                      ),
                      Gap(10),
                      Text(
                        " البريد الالكتروني  ",
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 59, 115, 160),
                        ),
                      ),
                      Gap(10),

                      CustomTextForm(
                        hint: "username@gmail.com",
                        myController: email,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "يرجى ادخال البريد الالكتروني";
                          }
                          final bool emailValid = RegExp(
                            r"^[a-zA-Z0-9._%-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$",
                          ).hasMatch(val);
                          if (!emailValid) {
                            return "يرجى إدخال بريد إلكتروني صالح";
                          }
                          return null;
                        },
                      ),
                      Gap(10),
                      Text(
                        "كلمة السر  ",
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 59, 115, 160),
                        ),
                      ),
                      Gap(10),

                      CustomTextForm(
                        hint: "******",
                        myController: password,
                        ispasswordfield: true,
                        obscuretext: true,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "يرجى ادخال كلمة سر";
                          }
                          if (val.length < 6) {
                            return "يجب ان تكون كلمة السر اكبر من 6 احرف";
                          }
                          return null;
                        },
                      ),
                      // ظهور رسالة الخطأ
                      if (provider.errorMessage != null)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: TextForm(
                            text: provider.errorMessage!,
                            size: 18,
                            color: Colors.red,
                            align: TextAlign.right,
                          ),
                        ),
                      Gap(20),
                      Center(
                        child: ButtonForm(
                          padding: EdgeInsets.symmetric(horizontal: 130),
                          borderradius: BorderRadiusGeometry.circular(20),
                          onPressed: provider.isLoading ? null : register,

                          title: "استمر",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
