import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course.dart';
import 'course_data_source.dart';

class CourseApiService implements CourseDataSource {
  final String baseUrl;
  CourseApiService(this.baseUrl);
  final _headers = {'Content-Type': 'application/json'};

  @override
  Future<List<Course>> getCourses() async {
    final res = await http.get(Uri.parse('$baseUrl/courses'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body) as List;
      return data.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('HTTP Error ${res.statusCode}');
  }

  @override
  Future<Course> createCourse(Course c) async {
    final res = await http.post(Uri.parse('$baseUrl/courses'), headers: _headers, body: jsonEncode(c.toJson()));
    if (res.statusCode == 200 || res.statusCode == 201) return Course.fromJson(jsonDecode(res.body));
    throw Exception('Gagal create');
  }

  @override
  Future<void> updateCourse(int id, Course c) async {
    final res = await http.put(Uri.parse('$baseUrl/courses/$id'), headers: _headers, body: jsonEncode(c.toJson()));
    if (res.statusCode >= 300) throw Exception('Gagal update');
  }

  @override
  Future<void> deleteCourse(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/courses/$id'));
    if (res.statusCode >= 300) throw Exception('Gagal delete');
  }
}