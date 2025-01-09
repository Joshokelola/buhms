//Room occupants table

class Booking {
    Booking({

    required this.userId,
    required this.roomId,
    required this.checkInDate,
  });

  final String userId;
  final String roomId;
  final DateTime checkInDate;

  @override
  String toString() => 'Booking(userId: $userId, roomId: $roomId, checkInDate: $checkInDate)';
}
