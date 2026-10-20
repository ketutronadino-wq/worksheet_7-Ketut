import 'package:flutter/material.dart';

const String studentName = 'Ketut Rona Dino';
const String studentId = '2415051108';

enum LayoutCategory { compact, medium, expanded }
LayoutCategory categoryFor(double w) => w < 600 ? LayoutCategory.compact : w < 840 ? LayoutCategory.medium : LayoutCategory.expanded;
String categoryLabel(LayoutCategory c) => c == LayoutCategory.compact ? 'Compact' : c == LayoutCategory.medium ? 'Medium' : 'Expanded';

class StatusStyle {
  final String label; final IconData icon; final Color color;
  const StatusStyle(this.label, this.icon, this.color);
}

StatusStyle statusStyle(String s) {
  if (s == 'done') return const StatusStyle('Selesai', Icons.check_circle, Colors.green);
  if (s == 'active') return const StatusStyle('Aktif', Icons.hourglass_top, Colors.orange);
  return const StatusStyle('Direncanakan', Icons.schedule, Colors.blueGrey);
}