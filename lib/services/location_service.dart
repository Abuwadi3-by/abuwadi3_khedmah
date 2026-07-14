import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:graduation_project/model/governorate_model.dart';
import 'package:graduation_project/processing/api_exception.dart';
import 'package:graduation_project/services/api_service.dart';

class LocationService {
  final ApiService _service = ApiService();
  Future<List<GovernorateModel>> getGovernorate() async {
    try {
      final response = await _service.get('governorates');

      if (response == null) {
        throw Exception('لا يوجد محافظات');
      }
      if (response is List) {
        return response.map((item) => GovernorateModel.fromJson(item)).toList();
      } else if (response is Map && response.containsKey('data')) {
        return (response['data'] as List)
            .map((item) => GovernorateModel.fromJson(item))
            .toList();
      } else {
        throw Exception('شكل الاستجابة غير متوقع');
      }
    } on DioException catch (e) {
      final customerError = ApiException.handelError(e);
      debugPrint("Error GetGovernorate : $e ");
      throw customerError.message;
    } catch (e) {
      debugPrint('Error in Governorate : $e');
      throw "حدث خطأ في جلب المحافظات ";
    }
  }

  Future<List<CityModel>> getCity(int governorateId) async {
    try {
      final response = await _service.get('governorates/$governorateId/cities');
      if (response == null) {
        throw Exception('لا يوجد مدن متوفرة في هذه المحافظة ');
      }
      if (response is List) {
        return response.map((item) => CityModel.fromJson(item)).toList();
      } else if (response is Map && response.containsKey('data')) {
        return (response['data'] as List)
            .map((item) => CityModel.fromJson(item))
            .toList();
      } else {
        throw Exception('شكل الاستجابة غير متوقع');
      }
    } on DioException catch (e) {
      final customerError = ApiException.handelError(e);
      throw customerError.message;
    } catch (e) {
      debugPrint("Error in GetCities : $e");
      throw "حدث خطأ في جلب المدن";
    }
  }
}
