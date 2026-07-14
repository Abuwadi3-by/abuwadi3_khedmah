import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/text%20form%20field.dart';
import 'package:graduation_project/components/text%20form.dart';
import 'package:graduation_project/providers/complaint_provider.dart';
import 'package:provider/provider.dart';

class Complaint extends StatefulWidget {
  final int reportedUserId;
  final String reportedUserName;
  Complaint({
    super.key,
    required this.reportedUserId,
    required this.reportedUserName,
  });

  @override
  State<Complaint> createState() => _ComplaintState();
}

class _ComplaintState extends State<Complaint> {
  TextEditingController complaint = TextEditingController();

  GlobalKey<FormState> comkey = GlobalKey<FormState>();

  @override
  void dispose() {
    complaint.dispose();

    super.dispose();
  }

  // ── Submit
  Future<void> _submit() async {
    // if (!comkey.currentState!.validate()) return;//////////////////////

    await context.read<ComplaintProvider>().submitComplaint(
      complaintText: complaint.text.trim(),
      reportedUserId: widget.reportedUserId,
    );

    if (!mounted) return;

    final provider = context.read<ComplaintProvider>();

    if (provider.isSuccess) {
      // تفربغ الحقل
      complaint.clear();

      // اظهار شريط سفلي
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "تم إرسال الشكوى إلى مسؤول التطبيق. سيتم معالجتها قريباً.",
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 14),
          ),
          backgroundColor: Color(0xFF1976D2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(12),
          duration: Duration(seconds: 2),
        ),
      );

      // اغلاق الصفحة تلقائياً بعد نجاح الارسال
      await Future.delayed(Duration(seconds: 2));
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ComplaintProvider>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shadowColor: Colors.black,
        toolbarHeight: 60,
        centerTitle: true,
        title: TextForm(
          text: "شكوى",
          size: 43,
          weight: FontWeight.bold,
          color: Colors.blue[900],
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.all(15),
            iconSize: 30,
            onPressed: () {
              context.read<ComplaintProvider>().reset();
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_forward_outlined),
          ),
        ],
        backgroundColor: Colors.blue[400],
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: comkey,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextForm(text: "اضف شكوى ", size: 30, weight: FontWeight.bold),
                Gap(8),
                CustomTextForm(
                  hint: "اريد الابلاغ عن فلان بسبب ضرر /اخذ كلفة زائدة ",
                  myController: complaint,
                  maxlines: 6,
                  validator: (val) {
                    if (val == null || val.isEmpty) return "يرجى إضافة وصف";
                    if (val.length < 10) return "الوصف قصير جداً، أضف المزيد";
                    return null;
                  },
                ),
                Gap(20),

                /// اذا حدث خطأ
                if (provider.errorMessage != null)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Text(
                      provider.errorMessage!,
                      textAlign: TextAlign.right,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),

                Gap(20),
                // زر ارسال الشكوى
                Center(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: provider.isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[400],
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 2,
                      ),
                      child: provider.isSubmitting
                          ? SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "إرسال إلى المسؤول",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
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
