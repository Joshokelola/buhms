import 'package:buhms/features/maintenance/domain/maintenance.dart';
import 'package:flutter/material.dart';

class AdminDashboardItem {
  AdminDashboardItem({
    required this.title,
    required this.color,
    this.requests,
    this.count,
  });

  List<MaintenanceRequest>? requests;
  String? count;
  final String title;
  final Color color;
}
