import '../models/course.dart';
import '../services/course_data_source.dart';

class CourseRepository {
  final CourseDataSource dataSource;
  CourseRepository(this.dataSource);

  Future<List<Course>> getCourses() => dataSource.getCourses();
  Future<Course> createCourse(Course c) => dataSource.createCourse(c);
  Future<void> updateCourse(int id, Course c) => dataSource.updateCourse(id, c);
  Future<void> deleteCourse(int id) => dataSource.deleteCourse(id);
}