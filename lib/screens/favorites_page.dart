import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import 'course_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favs = context.watch<CourseProvider>().favoriteCourses;
    return Scaffold(
      appBar: AppBar(title: const Text('Favorit')),
      body: favs.isEmpty ? const Center(child: Text('Belum ada favorit')) : ListView.builder(
        itemCount: favs.length,
        itemBuilder: (context, i) => ListTile(
          title: Text(favs[i].title),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CourseDetailPage(course: favs[i]))),
        ),
      ),
    );
  }
}