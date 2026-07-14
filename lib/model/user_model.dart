class UserModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? role; // "user" أو "professional"
  final String? governorateId;
  final String? cityId;
  final String? imageUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.role,
    this.governorateId,
    this.cityId,
    this.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone']?.toString(),
      role: json['role']?.toString(),
      governorateId: json['governorate_id']?.toString(),
      cityId: json['city_id']?.toString(),
      imageUrl: json['image'] ?? json['tools_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'governorate_id': governorateId,
      'city_id': cityId,
      'image': imageUrl,
    };
  }
}
