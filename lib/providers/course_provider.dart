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
      // Ambil data student dari JSON lokal (Pertemuan 6)
      final str = await rootBundle.loadString('assets/data/student_data.json');
      _student = (jsonDecode(str) as Map<String, dynamic>)['student'];
      
      // Ambil data courses dari Backend (Pertemuan 7)
      _courses = await repository.getCourses();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false; notifyListeners();
    }
  }

  Future<bool> createCourse(Course c) async {
    _isSaving = true; notifyListeners();
    try { await repository.createCourse(c); await loadAll(); return true; }
    catch (e) { _error = e.toString(); return false; }
    finally { _isSaving = false; notifyListeners(); }
  }

  Future<bool> updateCourse(int id, Course c) async {
    _isSaving = true; notifyListeners();
    try { await repository.updateCourse(id, c); await loadAll(); return true; }
    catch (e) { _error = e.toString(); return false; }
    finally { _isSaving = false; notifyListeners(); }
  }

  Future<bool> deleteCourse(int id, String code) async {
    _isSaving = true; notifyListeners();
    try { await repository.deleteCourse(id); _favorites.remove(code); await loadAll(); return true; }
    catch (e) { _error = e.toString(); return false; }
    finally { _isSaving = false; notifyListeners(); }
  }
}