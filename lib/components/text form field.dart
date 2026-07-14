import 'package:flutter/material.dart';

class CustomTextForm extends StatefulWidget {
  final String hint;
  final TextEditingController myController;
  final bool obscuretext;
  final bool ispasswordfield;
  final bool enabled;
  final int? maxlines;
  final Icon? prefixIcon;
  final List<String>? dropdownItems;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  const CustomTextForm({
    super.key,
    required this.hint,
    required this.myController,
    this.ispasswordfield = false, //(الحالة الافتراضية لا) هل هو حقل لكلمة السر
    this.obscuretext = false, // text الكلام ظاهر بال
    this.enabled = false, // الحقل غير قابل للكتابة فيه
    this.prefixIcon, // اضافة ايقونة للحقل عند الحاجة
    this.dropdownItems,
    this.maxlines = 1,
    this.validator,
    this.onChanged,
  });
  /* 
         (enabled = true) لا يمكنني اضافة هذه الايقونة إلا عندما تكون ال 

    */
  @override
  State<CustomTextForm> createState() => _CustomTextForm();
}

class _CustomTextForm extends State<CustomTextForm> {
  late bool currentobscure; // متغير  لاظهار واخفاء للكلام
  String selectedLocation = "";

  @override
  void initState() {
    super.initState();

    currentobscure = widget.obscuretext;
  }

  void showDropdown(BuildContext context) {
    if (widget.dropdownItems == null || widget.dropdownItems!.isEmpty) return;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return ListView.builder(
          itemCount: widget.dropdownItems!.length,
          itemBuilder: (context, index) {
            String item = widget.dropdownItems![index];
            return ListTile(
              title: Text(item, textAlign: TextAlign.right),
              onTap: () {
                setState(() {
                  selectedLocation = item;
                });
                widget.myController.text =
                    item; // اظهار النص المختار من القائمة في الحقل
                // تفعيل الـ onChanged لتمرير القيمة المحددة للصفحة فوراً
                if (widget.onChanged != null) {
                  widget.onChanged!(item);
                }
                Navigator.pop(context); // إغلاق القائمة
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        if (widget.enabled == true) {
          showDropdown(context);
        } else {
          null;
        }
      },
      obscureText: currentobscure, // text الكلام غير محجوب بال
      cursorColor: Colors.blue[200],
      textAlign: TextAlign.right,
      controller: widget.myController,
      readOnly: widget.enabled,
      maxLines: widget.maxlines,
      keyboardType: widget.maxlines! > 1
          ? TextInputType.multiline
          : TextInputType.text,
      validator: widget.validator,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        suffixIcon:
            widget
                .ispasswordfield // تظهر الايقونة عندما يكون الحقل لكلمة السر
            ? IconButton(
                //  اظهر الايقونةtrue  اذا
                onPressed: () {
                  setState(() {
                    currentobscure = !currentobscure;
                  });
                },
                icon: Icon(
                  currentobscure ? Icons.visibility_off : Icons.visibility,
                  color: const Color.fromARGB(255, 59, 115, 160),
                ),
              )
            : null, // لا تظهر الايقونة و يبقى الكلام ظاهراً false اذا
        fillColor: Colors.grey[50],
        filled: true,
        hintText: widget.hint,

        hintStyle: TextStyle(fontSize: 15, color: Colors.grey[400]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          gapPadding: 10,
          borderSide: BorderSide(color: const Color(0xFFE3F2FD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: const Color(0xFFE3F2FD), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          gapPadding: 10,
          borderSide: BorderSide(color: const Color(0xFFE3F2FD)),
        ),
      ),
    );
  }
}
