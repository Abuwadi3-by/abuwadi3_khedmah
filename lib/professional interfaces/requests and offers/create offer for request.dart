import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/button%20form.dart';
import 'package:graduation_project/components/text%20form%20field.dart';
import 'package:graduation_project/components/text%20form.dart';
import 'package:graduation_project/providers/create_offer_provider.dart';
import 'package:graduation_project/providers/professional_requests_provider.dart';
import 'package:provider/provider.dart';

class CreateOfferForRequest extends StatefulWidget {
  const CreateOfferForRequest({super.key});

  @override
  State<CreateOfferForRequest> createState() => OfferDet();
}

class OfferDet extends State<CreateOfferForRequest> {
  final TextEditingController details = TextEditingController();
  final TextEditingController time = TextEditingController();
  final TextEditingController price = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late CreateOfferProvider provider;

  @override
  void initState() {
    provider = context.read<CreateOfferProvider>();
    super.initState();
  }

  @override
  void dispose() {
    details.dispose();
    time.dispose();
    price.dispose();
    Future.microtask(() {
      provider.reset();
    });
    super.dispose();
  }

  Future<void> submit() async {
    context.read<CreateOfferProvider>().reset();

    if (!formKey.currentState!.validate()) return;

    // احضار معرف الطلب الذي المهني يقدم عرض له
    final request = context.read<ProfessionalRequestsProvider>().selected;
    if (request == null) return;

    await context.read<CreateOfferProvider>().submitOffer(
      requestId: request['id'],
      price: price.text.trim(),
      details: details.text.trim(),
      estimatedTime: time.text.trim(),
    );

    if (!mounted) return;

    final provider = context.read<CreateOfferProvider>();

    if (provider.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم إرسال العرض بنجاح ✓"),
          backgroundColor: Color(0xFF2E7D32),
        ),
      );
      Navigator.of(context).pop(); // go back to request details
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreateOfferProvider>();

    final request = context.watch<ProfessionalRequestsProvider>().selected;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blue[400],
        title: TextForm(
          text: "تقديم عرض",
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
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(15),
          children: [
            Gap(10),
            if (request != null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Color(0xFF1976D2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextForm(
                      text: request['title'] ?? '',
                      size: 16,
                      weight: FontWeight.bold,
                      color: Colors.white,
                      align: TextAlign.right,
                    ),
                    Gap(6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextForm(
                          text: request['location'] ?? '',
                          size: 13,
                          color: Colors.white70,
                        ),
                        Gap(4),
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.white70,
                          size: 14,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            Gap(15),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF1976D2).withOpacity(0.08),
                    blurRadius: 14,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextForm(
                    text: "السعر (ل.س)",
                    size: 27,
                    weight: FontWeight.bold,
                  ),
                  Gap(10),
                  CustomTextForm(
                    hint: "",
                    myController: price,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "يرجى إدخال السعر";
                      }
                      if (double.tryParse(val) == null) {
                        return "الرجاء إدخال رقم صحيح";
                      }
                      return null;
                    },
                  ),
                  Gap(15),
                  TextForm(
                    text: "التفاصيل ",
                    size: 28,
                    weight: FontWeight.bold,
                  ),
                  Gap(10),
                  CustomTextForm(
                    hint: "",
                    myController: details,
                    maxlines: 8,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "يرجى إدخال تفاصيل العرض";
                      }
                      if (val.length < 10) {
                        return "التفاصيل قصيرة جداً، أضف المزيد";
                      }
                      return null;
                    },
                  ),
                  Gap(15),
                  TextForm(
                    text: "الوقت المقدر لإنهاء العمل",
                    size: 27,
                    weight: FontWeight.bold,
                  ),
                  Gap(10),
                  CustomTextForm(
                    hint: "",
                    myController: time,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "مثال: يومان / 3 ساعات";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            Gap(20),
            if (provider.errorMessage != null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: TextForm(
                  text: provider.errorMessage!,
                  size: 18,
                  align: TextAlign.right,
                  color: Colors.red,
                ),
              ),
            Gap(20),
            Center(
              child: ButtonForm(
                onPressed: provider.isSubmitting ? null : submit,
                title: "ارسال",
                borderradius: BorderRadius.circular(15),
                padding: EdgeInsets.symmetric(horizontal: 80),
              ),
            ),
            Gap(20),
          ],
        ),
      ),
    );
  }
}
