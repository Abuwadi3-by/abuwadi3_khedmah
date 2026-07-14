import 'package:flutter/material.dart';
import 'package:graduation_project/model/category_model.dart';
import 'package:graduation_project/services/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();

  List<CategoriesModel> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CategoriesModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // دالة جلب التصنيفات
  Future<void> loadCategories({bool forceRefresh = false}) async {
    // التحقق مما اذا كانت البيانات موجودة او انه يقوم بالتحميل
    if ((_categories.isNotEmpty && !forceRefresh) || _isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _categories = await _categoryService.getcategories();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("loadCategories Error : $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _categories = [];
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
