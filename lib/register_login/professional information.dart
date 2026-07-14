import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/button%20form.dart';
import 'package:graduation_project/components/image.dart';
import 'package:graduation_project/components/text%20form%20field.dart';
import 'package:graduation_project/components/text%20form.dart';
import 'package:graduation_project/providers/auth_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types
class Professional_Information extends StatefulWidget {
  const Professional_Information({super.key});

  @override
  State<Professional_Information> createState() => _Professional_Information();
}

// ignore: camel_case_types
class _Professional_Information extends State<Professional_Information> {
  final TextEditingController category = TextEditingController();
  final TextEditingController yearexperence = TextEditingController();
  final TextEditingController description = TextEditingController();
  // key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();

  File? toolsimage;
  bool submitted = false;

  final List<String> categories = [
    "كهرباء",
    "سباكة",
    "نجار",
    "حدادة",
    "دهان",
    "تبريد وتكييف",
    "تنظيف",
    "نقل اثاث",
    "تركيب كاميرات",
    "تنسيق حدائق",
    "تركيب انترنت",
    "نقل عام",
    "تعقيم",
    "غسيل سيارات",
    "تركيب زجاج",
    "بلاط",
  ];
  @override
  void dispose() {
    category.dispose();
    yearexperence.dispose();
    description.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(16, 20, 16, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextForm(
              text: "اختر مصدر الصورة",
              size: 22,
              weight: FontWeight.bold,
              color: Color(0xFF0D47A1),
            ),
            Gap(12),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: Color(0xFFE3F2FD),
              onTap: () => Navigator.pop(context, ImageSource.camera),
              leading: Icon(
                Icons.camera_alt,
                color: Color.fromARGB(255, 59, 115, 160),
              ),
              title: Text("الكاميرا", style: TextStyle(fontSize: 16)),
            ),
            Gap(8),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: Color(0xFFE3F2FD),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
              leading: Icon(
                Icons.photo_library,
                color: Color.fromARGB(255, 59, 115, 160),
              ),
              title: Text("معرض الصور", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final XFile? picked = await picker.pickImage(
      source: source,
      imageQuality: 80, // ضغط الصورة
      maxWidth: 1000, // تقليل حجم الصورة
    );

    if (picked != null) {
      setState(() => toolsimage = File(picked.path));
    }
  }

  Future<void> submit() async {
    setState(() => submitted = true);
    context.read<AuthProvider>().clearError();

    // image is mandatory
    if (toolsimage == null) return;

    if (!formKey.currentState!.validate()) return;

    final success = await context.read<AuthProvider>().saveProfessionalInfo(
      category: category.text,
      yearsExperience: yearexperence.text.trim(),
      description: description.text,
      toolsImage: toolsimage!,
    );

    if (!mounted) return;

    ///للحماية ,لو أن المستخدم اختار صورة وفي نفس اللحظة ضغط على زر "رجوع" وأغلق الصفحة، هذا السطر يمنع الكود من الاستمرار في العمل

    if (success) {
      Navigator.of(context).pushReplacementNamed("professionalhomepage");
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shadowColor: Colors.black,
        toolbarHeight: 60,
        centerTitle: true,
        backgroundColor: Colors.blue[400],
        title: TextForm(
          text: "معلومات اخرى ",
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
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            Insert_Image(
              image: "images/khedma 3.png",
              height: 150,
              width: 150,
              color: Colors.white,
            ),
            Gap(10),
            SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextForm(
                    text: "اختر الخدمة التي تقدمها",
                    size: 30,
                    weight: FontWeight.bold,
                  ),
                  Gap(10),
                  TextForm(text: "الخدمة\t", size: 28),

                  CustomTextForm(
                    hint: "الخدمة",
                    myController: category,
                    enabled: true,
                    prefixIcon: Icon(
                      Icons.arrow_drop_down_sharp,
                      color: const Color.fromARGB(255, 59, 115, 160),
                    ),
                    dropdownItems: categories,
                    validator: (val) {
                      if (val == null || val.isEmpty)
                        return "يرجى اختيار الخدمة";
                      return null;
                    },
                  ),
                  Gap(10),
                  TextForm(text: "سنين الخبرة\t", size: 27),
                  Gap(10),
                  CustomTextForm(
                    hint: "",
                    myController: yearexperence,
                    validator: (val) {
                      if (val == null || val.isEmpty)
                        return "يرجى إدخال سنوات الخبرة";
                      if (int.tryParse(val.trim()) == null)
                        return "يرجى إدخال رقم صحيح";
                      if (int.parse(val.trim()) < 0)
                        return "لا يمكن أن تكون سنوات الخبرة سالبة";
                      return null;
                    },
                  ),
                  Gap(10),
                  TextForm(text: "اضافة وصف عنك\t", size: 27),
                  Gap(10),
                  CustomTextForm(
                    hint: ".... الوصف",
                    myController: description,
                    maxlines: 3,
                    validator: (val) {
                      if (val == null || val.isEmpty) return "يرجى إضافة وصف";
                      if (val.length < 10) return "الوصف قصير جداً، أضف المزيد";
                      return null;
                    },
                  ),
                  Gap(8),
                  TextForm(text: "اضافة صورة الادوات المستخدمة\t", size: 27),
                  Gap(10),
                  GestureDetector(
                    onTap: pickImage,
                    child: toolsimage != null
                        ? Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.file(
                                  toolsimage!,
                                  width: double.infinity,
                                  height: 180,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // remove button
                              Positioned(
                                top: 8,
                                left: 8,
                                child: GestureDetector(
                                  onTap: () {},
                                  // setState(() => toolsimage = null),/////////////////////////////////////////////////
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.black.withOpacity(
                                      0.6,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.55),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "تغيير الصورة",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Gap(4),
                                      Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            width: double.infinity,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                // red border after submit if no image
                                color: (submitted && toolsimage == null)
                                    ? Colors.red
                                    : Color.fromARGB(255, 59, 115, 160),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 45,
                                  color: (submitted && toolsimage == null)
                                      ? Colors.red
                                      : Color.fromARGB(255, 59, 115, 160),
                                ),
                                Gap(8),
                                Text(
                                  "اضغط لإضافة صورة",
                                  style: TextStyle(
                                    //////////////////////////////
                                    color: (submitted && toolsimage == null)
                                        ? Colors.red
                                        : Color.fromARGB(255, 59, 115, 160),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                  if (submitted && toolsimage == null)
                    Padding(
                      padding: EdgeInsets.only(top: 6, right: 4),
                      child: Text(
                        "يرجى إضافة صورة الأدوات",
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  Gap(15),
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
                      child: Text(
                        provider.errorMessage!,
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  Center(
                    child: ButtonForm(
                      padding: EdgeInsets.symmetric(horizontal: 130),
                      borderradius: BorderRadiusGeometry.circular(20),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          "professionalhomepagr",
                        );
                        // Navigator.of(
                        //   context,
                        // ).pushReplacementNamed("professionalhomepage");
                      },
                      // provider.isLoading ? null : submit,
                      title: "متابعة ",
                    ),
                  ),
                  Gap(20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
