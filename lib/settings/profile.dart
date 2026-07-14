import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/app_states.dart';
import 'package:graduation_project/components/button%20form.dart';
import 'package:graduation_project/components/primary%20color.dart';
import 'package:graduation_project/components/profile%20item.dart';
import 'package:graduation_project/components/text%20form.dart';
import 'package:graduation_project/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProfileProvider>().fetchProfile());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: AppColor.backgroundcolor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blue[400],
        title: TextForm(
          text: "الملف الشخصي",
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

      body: provider.isLoading
          ? AppStates.buildLoadingState()
          : provider.profile ==
                null // ← new guard
          ? AppStates.buildLoadingState()
          : provider.errorMessage != null
          ? AppStates.buildErrorState(
              provider.errorMessage!,
              onRetry: () => context.read<ProfileProvider>().fetchProfile(),
            )
          : buildBody(provider),
    );
  }

  Widget buildBody(ProfileProvider provider) {
    final profile = provider.profile ?? {};
    final bool isPro = provider.isProfessional;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Gap(15),
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  // يوجد صورة شخصية  , اذا نجح التحميل تظهر الصورة
                  // و اذا لم ينجح التحميل لا تظهر الصورة
                  backgroundImage: provider.avatarFile != null
                      ? FileImage(provider.avatarFile!)
                      : null,
                  foregroundImage:
                      provider.avatarFile == null &&
                          provider.avatarUrl != null &&
                          provider.avatarUrl!.isNotEmpty
                      ? NetworkImage(provider.avatarUrl!)
                      : null,
                  // لا يوجد صورة شخصية
                  // تظهر الايقونة
                  child: !provider.hasAvatar
                      ? Icon(Icons.person, size: 55, color: Color(0xFF1976D2))
                      : null,
                ),

                // عند اختيار صورة تظهر دائرة تحميل خفيفة مكان الصورة وبعدها تظهر الصورة
                if (provider.isUploading)
                  Positioned.fill(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.black26,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Gap(10),
          Center(
            child: TextForm(
              text: isPro ? "مهني " : "",
              size: 25,
              weight: FontWeight.bold,
              color: Color(0xFF1976D2),
            ),
          ),
          Gap(30),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                ProfileDataItems(
                  title: "الاسم",
                  subtitle: profile['name'] ?? '',
                  icon: Icons.person,
                ),
                Gap(6),
                ProfileDataItems(
                  title: "الموقع",
                  subtitle: profile['location'] ?? '',
                  icon: Icons.location_on,
                ),
                Gap(6),
                ProfileDataItems(
                  title: "رقم الهاتف",
                  subtitle: profile['phone'] ?? '',
                  icon: Icons.phone,
                ),
                Gap(6),
                ProfileDataItems(
                  title: "البريد الالكتروني",
                  subtitle: profile['email'] ?? '',
                  icon: Icons.mark_email_read_rounded,
                ),

                // حقول تظهر للمهني فقط
                if (isPro) ...[
                  Gap(6),
                  ProfileDataItems(
                    title: "وصف الخدمة",
                    subtitle: profile['description'] ?? '',
                    icon: Icons.description_outlined,
                  ),
                  Gap(6),
                  ProfileDataItems(
                    title: "سنوات الخبرة",
                    subtitle: "${profile['experience'] ?? '0'} سنوات",
                    icon: Icons.workspace_premium_outlined,
                  ),
                ],
              ],
            ),
          ),

          Gap(20),

          // زر تعديل الملف الشخصي
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: ButtonForm(
              onPressed: () {
                Navigator.pushNamed(context, "editeprofile");
              },
              title: "تعديل الملف الشخصي",
              borderradius: BorderRadius.circular(15),
              height: 48,
              color: Color(0xFF1976D2),
              padding: EdgeInsets.symmetric(horizontal: 50),
            ),
          ),
          Gap(30),
        ],
      ),
    );
  }
}
