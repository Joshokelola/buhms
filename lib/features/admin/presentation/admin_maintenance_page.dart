import 'package:auto_route/auto_route.dart';
import 'package:buhms/features/admin/domain/admin_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

@RoutePage()
class AdminMaintenancePage extends ConsumerStatefulWidget {
  const AdminMaintenancePage(this.dashboardItems, {super.key});
  final AdminDashboardItem dashboardItems;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdminMaintenancePageState();
}

String _formatDate(DateTime date) {
  return DateFormat('d/M/yy HH:mm').format(date);
}

class _AdminMaintenancePageState extends ConsumerState<AdminMaintenancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F3A4D),
        title: const Text('Maintenance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Maintenance Requests',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F3A4D),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F3A4D),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('New Request'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.dashboardItems.requests?.length,
                  itemBuilder: (context, index) {
                    final request = widget.dashboardItems.requests?[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          request!.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Submitted: ${_formatDate(request.dateRequested)}',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: request.status == RequestStatus.pending.name
                                ? const Color(0xFFFFF3CD)
                                : const Color(0xFFD4EDDA),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            request.status == RequestStatus.pending.name
                                ? 'PENDING'
                                : 'COMPLETED',
                            style: TextStyle(
                              color:
                                  request.status == RequestStatus.pending.name
                                      ? const Color(0xFF856404)
                                      : const Color(0xFF155724),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum RequestStatus { pending, completed, inProcess }
