class CategoriesModel {
  final int id;
  final String name;

  CategoriesModel({required this.id, required this.name});

  factory CategoriesModel.fromJson(Map<String, dynamic> data) {
    return CategoriesModel(
      id: (data['category_id'] as num)
          .toInt(), // لضمان عدم حدوث خطأ وجلب المعرف كرقم
      name: (data['name'] as String).trim(),
    );
  }
  // String get imagepath {
  //   const Map<String, String> localImage = {
  //     "كهرباء": "images/khedma_electricity.png",
  //     "سباكة": "images/khedma_plumbing.png",
  //     "نجار": "images/khedma_carpentry.png",
  //     "حدادة": "images/khedma_metalwork.png",
  //     "دهان": "images/khedma_painting.png",
  //     "تبريد وتكييف": "images/khedma_ac.png",
  //     "تنظيف": "images/khedma_cleaning.png",
  //     "نقل اثاث": "images/khedma_moving.png",
  //     "تركيب كاميرات": "images/khedma_cctv.png",
  //     "تركيب انترنت": "images/khedma_internet.png",
  //     "تنسيق حدائق": "images/khedma_landscaping.png",
  //     "تعقيم": "images/khedma_sanitization.png",
  //     "نقل عام": "images/khedma_public_transport.png",
  //     "غسيل سيارات": "images/khedma_car_wash.png",
  //     "تركيب زجاج": "images/khedma_glass.png",
  //   };

  //   return localImage[name] ?? 'images/khedma_home.png';
  // }
}
