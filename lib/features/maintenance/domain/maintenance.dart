class MaintenanceRequest {
  MaintenanceRequest({
    required this.title,
    required this.description,
    required this.dateRequested,
    required this.updatedAt,
    this.id,
    this.userId,
    this.roomId,
    this.status = 'pending',
    this.assignedTo,
    this.resolutionNotes,
    this.dateResolved,
  });
  factory MaintenanceRequest.defaultMaintenanceRequest() {
    return MaintenanceRequest(
      title: 'title',
      id: 'id',
      description: 'description',
      dateRequested: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
  // Factory constructor for creating a new MaintenanceRequest instance from a JSON map
  factory MaintenanceRequest.fromJson(Map<String, dynamic> json) {
    return MaintenanceRequest(
      title: json['title'] as String,
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      roomId: json['room_id'] as String?,
      description: json['description'] as String,
      dateRequested: DateTime.parse(json['date_requested'] as String),
      status: json['status'] as String? ?? 'pending',
      assignedTo: json['assigned_to'] as String?,
      resolutionNotes: json['resolution_notes'] as String?,
      dateResolved: json['date_resolved'] != null
          ? DateTime.parse(json['date_resolved'] as String)
          : null,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
  final String title;
  final String? id;
  final String? userId;
  final String? roomId;
  final String description;
  final DateTime dateRequested;
  String status;
  final String? assignedTo;
  String? resolutionNotes;
  DateTime? dateResolved;

  DateTime updatedAt;

  // Method for converting a MaintenanceRequest instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'id': id,
      'user_id': userId,
      'room_id': roomId,
      'description': description,
      'date_requested': dateRequested.toIso8601String(),
      'status': status,
      'assigned_to': assignedTo,
      'resolution_notes': resolutionNotes,
      'date_resolved': dateResolved?.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'MaintenanceRequest(id: $id, status: $status title: $title, userId: $userId, roomId: $roomId, description: $description, dateRequested: $dateRequested, assignedTo: $assignedTo)';
  }
}
