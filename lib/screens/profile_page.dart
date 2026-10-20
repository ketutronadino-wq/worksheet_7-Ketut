import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<CourseProvider>().student;
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 80),
            Text(s['name'] ?? 'Nama', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('NIM: ${s['nim'] ?? 'NIM'}'),
          ],
        ),
      ),
    );
  }
}