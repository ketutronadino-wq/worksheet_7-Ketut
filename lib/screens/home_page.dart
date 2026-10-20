import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<CourseProvider>();
    final student = p.student;
    final total = p.courses.length;
    final totalCredits = p.courses.fold<int>(0, (s, c) => s + c.credits);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(radius: 30, child: Icon(Icons.person, size: 35)),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(student['name'] ?? 'Nama', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('NIM: ${student['nim'] ?? 'NIM'}', style: const TextStyle(fontSize: 15)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Ringkasan Belajar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _card(Icons.menu_book, Colors.blue, '$total', 'Mata Kuliah')),
              const SizedBox(width: 12),
              Expanded(child: _card(Icons.stars, Colors.purple, '$totalCredits', 'Total SKS')),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.favorite, color: Colors.red, size: 30),
              title: Text('${p.favorites.length} Course Favorit'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(IconData icon, Color color, String val, String label) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 6),
            Text(val, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(label),
          ],
        ),
      ),
    );
  }
}