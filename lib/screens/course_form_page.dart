import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseFormPage extends StatefulWidget {
  final Course? course;
  const CourseFormPage({super.key, this.course});
  @override
  State<CourseFormPage> createState() => _CourseFormPageState();
}

class _CourseFormPageState extends State<CourseFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeCtrl, _titleCtrl, _creditsCtrl;
  String _status = 'planned';

  @override
  void initState() {
    super.initState();
    _codeCtrl = TextEditingController(text: widget.course?.code ?? '');
    _titleCtrl = TextEditingController(text: widget.course?.title ?? '');
    _creditsCtrl = TextEditingController(text: widget.course?.credits.toString() ?? '');
    _status = widget.course?.status ?? 'planned';
  }

  @override
  void dispose() { _codeCtrl.dispose(); _titleCtrl.dispose(); _creditsCtrl.dispose(); super.dispose(); }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    final c = Course(id: widget.course?.id, code: _codeCtrl.text, title: _titleCtrl.text, credits: int.parse(_creditsCtrl.text), status: _status);
    final p = context.read<CourseProvider>();
    bool ok = widget.course == null ? await p.createCourse(c) : await p.updateCourse(widget.course!.id!, c);
    
    if (!mounted) return;
    if (ok) { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil disimpan!'))); }
    else { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: ${p.error}'))); }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<CourseProvider>().isSaving;
    return Scaffold(
      appBar: AppBar(title: Text(widget.course == null ? 'Tambah Course' : 'Edit Course')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(controller: _codeCtrl, decoration: const InputDecoration(labelText: 'Code'), readOnly: widget.course != null, validator: (v) => v!.isEmpty ? 'Wajib' : null),
            TextFormField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Judul'), validator: (v) => v!.isEmpty ? 'Wajib' : null),
            TextFormField(controller: _creditsCtrl, decoration: const InputDecoration(labelText: 'SKS'), keyboardType: TextInputType.number, validator: (v) => int.tryParse(v ?? '') == null ? 'Harus angka' : null),
            DropdownButtonFormField<String>(
  initialValue: _status, decoration: const InputDecoration(labelText: 'Status'),
              items: ['planned', 'active', 'done'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) => setState(() => _status = val!),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: isSaving ? null : _simpan,
              child: isSaving ? const CircularProgressIndicator() : const Text('Simpan'),
            )
          ],
        ),
      ),
    );
  }
}