import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/button%20form.dart';
import 'package:graduation_project/components/image.dart';
import 'package:graduation_project/components/text%20form.dart';
import 'package:graduation_project/components/text%20form%20field.dart';
import 'package:graduation_project/providers/auth_provider.dart';
import 'package:graduation_project/providers/location_provider.dart';
import 'package:provider/provider.dart';

class RegisterInformation extends StatefulWidget {
  const RegisterInformation({super.key});

  @override
  State<RegisterInformation> createState() => _RegisterInformation();
}

class _RegisterInformation extends State<RegisterInformation> {
  final TextEditingController phone = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController governorate = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String? role;
  bool submitted = false; // تتبع اذا كانت المحاولة الاولى فيها اخطاء
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationProvider>().loadGovernorates();
    });
  }

  @override
  void dispose() {
    phone.dispose();
    governorate.dispose();
    city.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    setState(() => submitted = true);
    context.read<AuthProvider>().clearError();

    // التحقق من انه تم اختيار الدور
    if (role == null) return;

    // التحقق من المدينة
    // if (role == "user" && city.text.isEmpty) return;///////////////////////

    // if (!formkey.currentState!.validate()) return;///////////////////////////////////// الغاء التعليق عند الربط

    final locationprovider = context.read<LocationProvider>();

    final success = await context.read<AuthProvider>().saveUserInfo(
      phone: phone.text.trim(),
      role: role!,
      governorateId: locationprovider.selectgovernorate?.id.toString() ?? "",
      cityId: role == "user"
          ? locationprovider.selectcities?.id.toString()
          : null,
    );

    if (!mounted) return;

    if (success) {
      // الانتقال على حسب الدور
      if (role == "professional") {
        Navigator.of(context).pushReplacementNamed("otherinformation");
      } else {
        Navigator.of(context).pushReplacementNamed("customerhomepage");
      }
    }
  }

  Widget cityfield() {
    return Consumer<LocationProvider>(
      builder: (context, locationprovider, child) {
        List<String> cityName = locationprovider.cities
            .map((c) => c.name)
            .toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextForm(text: "المدينة\t", size: 28, weight: FontWeight.bold),
            Gap(8),
            CustomTextForm(
              hint: "المدينة ",
              myController: city,
              enabled: cityName.isNotEmpty,
              prefixIcon: Icon(
                Icons.arrow_drop_down_sharp,
                color: Color.fromARGB(255, 59, 115, 160),
              ),
              dropdownItems: cityName.isNotEmpty ? cityName : null,
              onChanged: (selectCityName) {
                final selectCity = locationprovider.cities.firstWhere(
                  (c) => c.name == selectCityName,
                );
                context.read<LocationProvider>().selectCities(selectCity);
                city.text = selectCityName;
              },
              validator: (val) {
                if (role == "user" && (val == null || val.isEmpty))
                  return "يرجى اختيار المدينة";
                return null;
              },
            ),
            // if (submitted &&
            //     role == "user" &&
            //     city.text.isEmpty) ////////////////// الغاء التعليق عند الربط
            //   Padding(
            //     padding: EdgeInsets.only(top: 5, right: 4),
            //     child: TextForm(
            //       text: "يرجى اختيار المدينة",
            //       size: 16,
            //       color: Colors.red,
            //     ),
            //   ),
          ],
        );
      },
    );
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
        title: TextForm(
          text: "معلومات",
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
        backgroundColor: Colors.blue[400],
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: formkey,
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
                    text: "يرجى اضافة المعلومات التالية",
                    size: 30,
                    weight: FontWeight.w600,
                  ),
                  Gap(2),
                  TextForm(text: "رقم الهاتف\t", size: 28),
                  Gap(8),

                  CustomTextForm(
                    hint: "09********",
                    myController: phone,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "يرجى ادخال رقم الهاتف";
                      }
                      if (val.length < 9) {
                        return "رقم الهاتف غير صحيح";
                      }
                      if (!RegExp(r'^[0-9+]+$').hasMatch(val.trim()))
                        return "يرجى ادخال رقم فقط";
                      return null;
                    },
                  ),
                  Gap(10),
                  TextForm(text: "الدور\t", size: 28),
                  RadioListTile(
                    activeColor: Color.fromARGB(255, 59, 115, 160),
                    controlAffinity: ListTileControlAffinity.trailing,
                    title: TextForm(
                      text: "مستخدم (طالب خدمة)",
                      weight: FontWeight.w600,
                      align: TextAlign.end,
                      size: 22,
                    ),
                    value: "user",
                    groupValue: role,
                    onChanged: (value) {
                      setState(() {
                        role = value;
                      });
                    },
                  ),
                  RadioListTile(
                    controlAffinity: ListTileControlAffinity.trailing,
                    activeColor: Color.fromARGB(255, 59, 115, 160),
                    title: TextForm(
                      text: "مهني (مقدّم خدمة)",
                      weight: FontWeight.w600,
                      align: TextAlign.end,
                      size: 22,
                    ),
                    value: "professional",
                    groupValue: role,
                    onChanged: (value) {
                      setState(() {
                        role = value;
                        city.clear();
                      });
                    },
                  ),
                  if (submitted && role == null)
                    Padding(
                      padding: EdgeInsets.only(right: 16, bottom: 6),
                      child: TextForm(
                        text: "يرجى اختيار الدور",
                        align: TextAlign.right,
                        size: 16,
                        color: Colors.red,
                      ),
                    ),
                  TextForm(text: "المحافظة\t", size: 28),
                  Gap(8),
                  Consumer<LocationProvider>(
                    builder: (context, locationprovider, child) {
                      List<String> governorateName = locationprovider
                          .governorates
                          .map((g) => g.name)
                          .toList();
                      return CustomTextForm(
                        hint: "المحافظة",
                        myController: governorate,
                        enabled: governorateName.isNotEmpty,
                        prefixIcon: Icon(
                          Icons.arrow_drop_down_sharp,
                          color: Color.fromARGB(255, 59, 115, 160),
                        ),
                        dropdownItems: governorateName.isNotEmpty
                            ? governorateName
                            : null,
                        onChanged: (selectGovName) {
                          final selectGov = locationprovider.governorates
                              .firstWhere((g) => g.name == selectGovName);
                          locationprovider.selectGovernorates(selectGov);
                          governorate.text = selectGovName;
                          city.clear();
                        },
                        validator: (val) {
                          if (val == null || val.isEmpty)
                            return "يرجى اختيار المحافظة";
                          return null;
                        },
                      );
                    },
                  ),

                  Gap(10),
                  if (role == "user") cityfield(),

                  Gap(15),
                  // عرض الاخطاء ان وجدت
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
                        align: TextAlign.right,
                        color: Colors.red,
                      ),
                    ),

                  Gap(15),
                  Center(
                    child: ButtonForm(
                      padding: EdgeInsets.symmetric(horizontal: 130),
                      borderradius: BorderRadiusGeometry.circular(20),
                      onPressed: provider.isLoading ? null : submit,
                      title: "متابعة",
                    ),
                  ),
                  Gap(30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
