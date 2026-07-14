import 'package:flutter/material.dart';
import 'package:graduation_project/model/governorate_model.dart';
import 'package:graduation_project/services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();

  List<GovernorateModel> _governorates = [];
  String? _governorateError;
  GovernorateModel? _selectgovernorate;

  List<CityModel> _cities = [];
  String? _citiesError;
  CityModel? _selectcities;

  List<GovernorateModel> get governorates => _governorates;
  String? get governorateError => _governorateError;
  GovernorateModel? get selectgovernorate => _selectgovernorate;

  List<CityModel> get cities => _cities;
  String? get citiesError => _citiesError;
  CityModel? get selectcities => _selectcities;
  //
  Future<void> loadGovernorates({bool forceRefresh = false}) async {
    if (_governorates.isNotEmpty && !forceRefresh) return;
    _governorateError = null;
    try {
      _governorates = await _locationService.getGovernorate();
      debugPrint("تم جلب ${_governorates.length} محافظة بنجاح ");
    } catch (e) {
      debugPrint("LoadGovernorates Erroe : $e ");
    } finally {
      notifyListeners();
    }
  }

  // دالة تعمل عند تغيير المحافظة , تفرَغ قائمة المدن وتملأها بالمدن التابعة للمحافظة
  void selectGovernorates(GovernorateModel? governorate) {
    _selectgovernorate = governorate;

    _selectcities = null;
    _cities = [];
    _citiesError = null;

    notifyListeners();
    // تجلب المدن تلقائباً بعد تغيير المحافظة
    if (governorate != null) {
      loadCities(governorate.id);
    }
  }

  Future<void> loadCities(int governorateId) async {
    _citiesError = null;
    try {
      _cities = await _locationService.getCity(governorateId);
    } catch (e) {
      _citiesError = e.toString();
      // _citiesError = "حدث خطأ اثناء حلب مدن هذه المحافظة";
      debugPrint("LoadCities Error : $e");
    } finally {
      notifyListeners();
    }
  }

  void selectCities(CityModel? city) {
    _selectcities = city;
    notifyListeners();
  }

  // عند الخروج من الواجهة تفريغ الحقول تلقائياً
  void resetLocation() {
    _governorates = [];
    _cities = [];
    _selectgovernorate = null;
    _selectcities = null;
    _governorateError = null;
    _citiesError = null;
    notifyListeners();
  }
}
