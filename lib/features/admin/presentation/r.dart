import 'package:flutter/material.dart';

class MaintenanceAdminView extends StatelessWidget {

  MaintenanceAdminView({super.key});
  final List<MaintenanceRequest> requests = [
    MaintenanceRequest(
      title: 'Faulty Sockets',
      submissionDate: '4/11/24 03:15',
      status: RequestStatus.pending,
    ),
    MaintenanceRequest(
      title: 'New Fans',
      submissionDate: '6/11/24 15:11',
      status: RequestStatus.pending,
    ),
    MaintenanceRequest(
      title: 'Fan Faulty',
      submissionDate: '4/11/24 01:05',
      status: RequestStatus.completed,
    ),
  ];

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
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          request.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Submitted: ${request.submissionDate}',
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
                            color: request.status == RequestStatus.pending
                                ? const Color(0xFFFFF3CD)
                                : const Color(0xFFD4EDDA),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            request.status == RequestStatus.pending
                                ? 'PENDING'
                                : 'COMPLETED',
                            style: TextStyle(
                              color: request.status == RequestStatus.pending
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

enum RequestStatus { pending, completed }

class MaintenanceRequest {

  MaintenanceRequest({
    required this.title,
    required this.submissionDate,
    required this.status,
  });
  final String title;
  final String submissionDate;
  final RequestStatus status;
}