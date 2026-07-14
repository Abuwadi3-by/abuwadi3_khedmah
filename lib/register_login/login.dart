import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/button%20form.dart';
import 'package:graduation_project/components/image.dart';
import 'package:graduation_project/components/text%20form.dart';
import 'package:graduation_project/components/text%20form%20field.dart';
import 'package:graduation_project/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  // key
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  Future<void> login() async {
    context.read<AuthProvider>().clearError();

    if (!formkey.currentState!.validate()) return;

    final success = await context.read<AuthProvider>().login(
      email: email.text.trim(),
      password: password.text,
    );

    if (!mounted) return;

    if (success) {
      // Navigator.of(context).pushReplacementNamed("home");
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: Form(
        key: formkey,
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 20, left: 300),
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
                  height: 450,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextForm(
                        text: "البريد الالكتروني\t",
                        size: 35,
                        weight: FontWeight.w600,
                        color: const Color.fromARGB(255, 59, 115, 160),
                      ),
                      Gap(10),
                      CustomTextForm(
                        hint: "username@gmail.com",
                        myController: email,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "ادخل البريد الالكتروني";
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
                      Gap(10),
                      TextForm(
                        text: "كلمة السر\t",
                        size: 35,
                        weight: FontWeight.w600,
                        color: const Color.fromARGB(255, 59, 115, 160),
                      ),
                      Gap(10),
                      CustomTextForm(
                        hint: "******",
                        myController: password,
                        ispasswordfield: true,
                        obscuretext: true,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return " ادخل كلمة السر";
                          }
                          return null;
                        },
                      ),
                      Gap(15),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "emailverification");
                        },
                        child: TextForm(
                          text: " ؟\t هل نسيت كلمة المرور",
                          weight: FontWeight.bold,
                          color: const Color.fromARGB(255, 59, 115, 160),
                          size: 22,
                        ),
                      ),
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
                      Gap(15),
                      ButtonForm(
                        padding: EdgeInsets.symmetric(horizontal: 110),
                        borderradius: BorderRadiusGeometry.circular(20),
                        onPressed: provider.isLoading ? null : login,
                        title: "تسجيل الدخول",
                      ),
                      Gap(10),
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
