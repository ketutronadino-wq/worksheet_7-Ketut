import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;
  CourseProvider(this.repository);

  List<Course> _courses = [];
  Map<String, dynamic> _student = {};
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;
  final Set<String> _favorites = {};

  List<Course> get courses => _courses;
  Map<String, dynamic> get student => _student;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;
  Set<String> get favorites => _favorites;
  List<Course> get favoriteCourses => _courses.where((c) => _favorites.contains(c.code)).toList();

  bool isFavorite(String code) => _favorites.contains(code);
  void toggleFavorite(String code) {
    _favorites.contains(code) ? _favorites.remove(code) : _favorites.add(code);
    notifyListeners();
  }

  Future<void> loadAll() async {
    _isLoading = true; _error = null; notifyListeners();
    try {
      // 1. Ambil data student & course dari file JSON lokal
      final str = await rootBundle.loadString('assets/data/student_data.json');
      final data = jsonDecode(str) as Map<String, dynamic>;
      
      _student = data['student'];
      _courses = (data['courses'] as List).map((e) => Course.fromJson(e)).toList();
      
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false; notifyListeners();
    }
  }

  // --- FUNGSI CRUD (Sementara simpan di memori lokal) ---
  Future<bool> createCourse(Course c) async {
    _isSaving = true; notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500)); // Simulasi loading
    _courses.add(c);
    _isSaving = false; notifyListeners();
    return true;
  }

  Future<bool> updateCourse(int id, Course c) async {
    _isSaving = true; notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _courses.indexWhere((element) => element.code == c.code);
    if (index != -1) _courses[index] = c;
    _isSaving = false; notifyListeners();
    return true;
  }

  Future<bool> deleteCourse(int id, String code) async {
    _isSaving = true; notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    _courses.removeWhere((element) => element.code == code);
    _favorites.remove(code);
    _isSaving = false; notifyListeners();
    return true;
  }
}