import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/button%20form.dart';
import 'package:graduation_project/components/text%20form%20field.dart';
import 'package:graduation_project/components/text%20form.dart';
import 'package:graduation_project/providers/category_provider.dart';
import 'package:graduation_project/providers/create_service_request_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ServiceRequest extends StatefulWidget {
  const ServiceRequest({super.key});

  @override
  State<ServiceRequest> createState() => _ServiceRequest();
}

class _ServiceRequest extends State<ServiceRequest> {
  late ServiceRequestProvider myProvider;
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  final TextEditingController categories = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController details = TextEditingController();

  int? selectedCategoryId; // معرّف التصنيف المختار (المطلوب فعلياً من الـ API)

  bool imageTouched = false; // حالة لم يتم الارسال بعد \ true اذا تم الارسال

  @override
  void initState() {
    myProvider = context.read<ServiceRequestProvider>();
    Future.microtask(() => context.read<CategoryProvider>().loadCategories());
    super.initState();
  }

  @override
  void dispose() {
    categories.dispose();
    address.dispose();
    details.dispose();
    Future.microtask(() {
      myProvider.reset();
    });

    super.dispose();
  }

  // اختيار الصورة اما من المعرض او فتح الكاميرا
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
              text: "",
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
              leading: Icon(Icons.camera_alt, color: Color(0xFF1976D2)),
              title: TextForm(text: "الكاميرا", size: 20),
            ),
            Gap(8),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: Color(0xFFE3F2FD),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
              leading: Icon(Icons.photo_library, color: Color(0xFF1976D2)),
              title: TextForm(text: "معرض الصور", size: 20),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 80, // ضغط الصورة الى %80 من حجمها الاصلي
      maxWidth: 1000, // تصغير حجم الصورة ليناسب ابعاد شاشة الموبايل
    );

    if (picked == null) return;

    if (mounted) {
      context.read<ServiceRequestProvider>().setImage(File(picked.path));
    }
  }

  // الارسال
  Future<void> submit() async {
    setState(() => imageTouched = true);

    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<ServiceRequestProvider>();

    await provider.submitRequest(
      categoryId: selectedCategoryId!,
      address: address.text,
      details: details.text,
    );

    if (!mounted) return;

    if (provider.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("تم إرسال الطلب بنجاح ✓"),
          backgroundColor: Color(0xFF2E7D32),
        ),
      );
      categories.clear();
      selectedCategoryId = null;
      address.clear();
      details.clear();
      setState(() => imageTouched = false);
      Navigator.of(context).pop();
    } else if (provider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage!),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServiceRequestProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      //
      //const Color.fromARGB(255, 228, 236, 248)
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blue[400],
        title: TextForm(
          text: "اضافة طلب",
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Gap(15),
              TextForm(
                text: "التصنيف\t",
                size: 30,
                weight: FontWeight.bold,
                color: Color.fromARGB(255, 59, 115, 160),
              ),
              Gap(10),
              Consumer<CategoryProvider>(
                builder: (context, categoryProvider, _) {
                  return CustomTextForm(
                    hint: "",
                    myController: categories,
                    prefixIcon: Icon(
                      Icons.arrow_drop_down,
                      color: Color.fromARGB(255, 59, 115, 160),
                    ),
                    enabled: true,
                    dropdownItems: categoryProvider.categories
                        .map((c) => c.name)
                        .toList(),
                    onChanged: (selectedName) {
                      final match = categoryProvider.categories.firstWhere(
                        (c) => c.name == selectedName,
                      );
                      setState(() => selectedCategoryId = match.id);
                    },
                    validator: (val) {
                      if (selectedCategoryId == null) {
                        return "يرجى اختيار التصنيف";
                      }
                      return null;
                    },
                  );
                },
              ),
              Gap(15),
              TextForm(
                text: "الموقع\t",
                size: 30,
                weight: FontWeight.bold,
                color: Color.fromARGB(255, 59, 115, 160),
              ),
              Gap(10),
              CustomTextForm(
                hint: "المحافظة / المدينة",
                myController: address,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "يرجى ادخال الموقع";
                  }
                  if (val.length < 5) {
                    return "الموقع قصير جدا";
                  }
                  return null;
                },
              ),
              Gap(15),
              TextForm(
                text: "تفاصيل الطلب\t",
                size: 30,
                weight: FontWeight.bold,
                color: Color.fromARGB(255, 59, 115, 160),
              ),
              Gap(10),
              CustomTextForm(
                hint: "",
                myController: details,
                maxlines: 3,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "يرجى ادخال تفاصيل الطلب";
                  }
                  return null;
                },
              ),
              Gap(15),
              TextForm(
                text: "ادراج صورة\t",
                size: 30,
                weight: FontWeight.bold,
                color: Color.fromARGB(255, 59, 115, 160),
              ),
              Gap(10),
              Container(
                width: double.infinity,
                // height: 110,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: BoxBorder.all(
                    color: Color.fromARGB(255, 59, 115, 160),
                    width: 1,
                  ),
                ),
                child: GestureDetector(
                  onTap: pickImage,
                  child: provider.selectedImage != null
                      ? Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                provider.selectedImage!,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // remove button
                            Positioned(
                              top: 8,
                              left: 8,
                              child: GestureDetector(
                                onTap: () => context
                                    .read<ServiceRequestProvider>()
                                    .removeImage(),
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
                            // change button
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextForm(
                                      text: "تغيير الصورة",
                                      size: 15,
                                      color: Colors.white,
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
                      // لا يوجد صورة , اظهار زر الاضافة
                      : Container(
                          width: double.infinity,
                          height: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Color.fromARGB(255, 59, 115, 160),
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo_outlined,
                                size: 45,
                                color: Color.fromARGB(255, 59, 115, 160),
                              ),
                              Gap(8),
                              TextForm(
                                text: "اضغط لاضافة صورة",
                                color: Color.fromARGB(255, 59, 115, 160),
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                ),
                //  IconButton(
                //   onPressed: () {},
                //   icon: Icon(Icons.add_a_photo_outlined, size: 50),
                //   color: const Color.fromARGB(255, 59, 115, 160),
                // ),
              ),
              Gap(15),
              Center(
                child: ButtonForm(
                  onPressed: provider.isSubmitting ? null : submit,
                  title: "ارسال الطلب",
                  borderradius: BorderRadius.circular(15),
                  padding: EdgeInsets.symmetric(horizontal: 100),
                ),
              ),
              Gap(30),
            ],
          ),
        ),
      ),
    );
  }
}
