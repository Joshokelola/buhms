import 'package:auto_route/auto_route.dart';
import 'package:buhms/app/router/app_router.gr.dart';
import 'package:buhms/features/maintenance/domain/maintenance.dart';
import 'package:buhms/features/maintenance/presentation/controllers/maintenance_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

@RoutePage()
class MaintenancePage extends ConsumerStatefulWidget {
  const MaintenancePage({super.key});

  @override
  ConsumerState<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends ConsumerState<MaintenancePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(maintenanceRequestProvider.notifier).getMaintenanceRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Maintenance Requests',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.pushRoute(const ComplaintSubmissionPage());
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                        child: const Text('New Request'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ref.watch(maintenanceRequestProvider).maybeWhen(
                    orElse: () {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    successful: (data) {
                      return Column(
                        children: [
                          ...data
                              .map((request) => RequestCard(request: request)),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: const Text(
          '© 2024 Bells University of Technology | Proudly designed by Group 6',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class RequestCard extends ConsumerWidget {
  const RequestCard({required this.request, super.key});
  final MaintenanceRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<String> decodeName(String staffId) async {
      final name = await ref
          .read(maintenanceRequestProvider.notifier)
          .getStaffName(staffId);
      return name;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  request.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ),
              StatusBadge(status: request.status),
            ],
          ),
          const SizedBox(height: 16),
          // if (request.roomId != null)
          //   DetailRow(label: 'Room', value: request.roomId!),
          DetailRow(
            label: 'Submitted',
            value: _formatDate(request.dateRequested),
          ),
          if (request.assignedTo != null)
            FutureBuilder<String>(
              future: decodeName(request.assignedTo!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const DetailRow(
                    label: 'Assigned To',
                    value: 'Loading...',
                  );
                }
                if (snapshot.hasError) {
                  return DetailRow(
                    label: 'Assigned To',
                    value: 'Error: ${snapshot.error}',
                  );
                }
                return DetailRow(
                  label: 'Assigned To',
                  value: snapshot.data ?? 'Unknown',
                );
              },
            ),
          if (request.resolutionNotes != null)
            DetailRow(
              label: 'Resolution Notes',
              value: request.resolutionNotes!,
            ),
          if (request.dateResolved != null)
            DetailRow(
              label: 'Resolved',
              value: _formatDate(request.dateResolved!),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('d/M/yy HH:mm').format(date);
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.status, super.key});
  final String status;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = const Color(0xFFFFF3CD);
        textColor = const Color(0xFF856404);
      case 'in progress':
        backgroundColor = const Color(0xFFCCE5FF);
        textColor = const Color(0xFF004085);
      case 'completed':
        backgroundColor = const Color(0xFFD4EDDA);
        textColor = const Color(0xFF155724);

      default:
        backgroundColor = const Color(0xFFE2E3E5);
        textColor = const Color(0xFF383D41);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(color: textColor, fontSize: 14),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  const DetailRow({required this.label, required this.value, super.key});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}
