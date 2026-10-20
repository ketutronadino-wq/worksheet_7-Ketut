import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseDetailPage extends StatelessWidget {
  final Course course;
  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<CourseProvider>();
    final isFav = p.isFavorite(course.code);

    return Scaffold(
      appBar: AppBar(title: Text(course.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(course.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('${course.code} • ${course.credits} SKS'),
            const SizedBox(height: 16),
            Text('Status: ${course.status}'),
            const SizedBox(height: 24),
            Row(
              children: [
                IconButton(
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                  onPressed: () => p.toggleFavorite(course.code),
                ),
                const Text('Favorit'),
              ],
            )
          ],
        ),
      ),
    );
  }
}