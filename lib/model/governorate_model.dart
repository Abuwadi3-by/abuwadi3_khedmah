class GovernorateModel {
  final int id;
  final String name;

  GovernorateModel({required this.id, required this.name});

  factory GovernorateModel.fromJson(Map<String, dynamic> data) {
    return GovernorateModel(id: data['governorate_id'], name: data['name']);
  }
}

class CityModel {
  final int id;
  final String name;
  final int governorateId;

  CityModel({
    required this.id,
    required this.governorateId,
    required this.name,
  });

  factory CityModel.fromJson(Map<String, dynamic> data) {
    return CityModel(
      id: data['city_id'],
      governorateId: data['governorate_id'],
      name: data['name'],
    );
  }
}
