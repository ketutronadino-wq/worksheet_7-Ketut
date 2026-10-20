import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/error_view.dart';
import 'course_form_page.dart';
import 'course_detail_page.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<CourseProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Mata Kuliah'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CourseFormPage())),
        child: const Icon(Icons.add),
      ),
      body: _body(context, p),
    );
  }

  Widget _body(BuildContext context, CourseProvider p) {
    if (p.isLoading) return const Center(child: CircularProgressIndicator());
    if (p.error != null) return ErrorView(message: p.error!, onRetry: p.loadAll);
    if (p.courses.isEmpty) return const Center(child: Text('Data kosong, silakan tambah.'));

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: p.courses.length,
      itemBuilder: (context, i) {
        final c = p.courses[i];
        return Card(
          child: ListTile(
            title: Text(c.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${c.code} • ${c.credits} SKS • ${c.status}'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CourseDetailPage(course: c))),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CourseFormPage(course: c)))),
                IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _hapus(context, c.id!, c.code)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _hapus(BuildContext context, int id, String code) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await context.read<CourseProvider>().deleteCourse(id, code);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}