import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<CourseProvider>();
    final student = p.student;
    return Scaffold(
      appBar: AppBar(title: const Text('Course Manager')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.person, size: 40),
              title: Text(student['name'] ?? 'Nama'),
              subtitle: Text('NIM: ${student['nim'] ?? 'NIM'}'),
            ),
          ),
          const SizedBox(height: 16),
          Text('Total Mata Kuliah: ${p.courses.length}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('Total Favorit: ${p.favorites.length}'),
        ],
      ),
    );
  }
}