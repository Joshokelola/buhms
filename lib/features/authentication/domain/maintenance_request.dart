class MaintenanceRequest {
    MaintenanceRequest({
    required this.id,
    required this.userId,
    required this.roomId,
    required this.description,
    required this.dateRequested,
    this.status = 'pending',
  });
  final String id;
  final String userId;
  final String roomId;
  final String description;
  final DateTime dateRequested;
  String status; // 'pending', 'in progress', 'completed'


}
