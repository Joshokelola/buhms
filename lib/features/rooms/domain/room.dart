import 'package:buhms/features/authentication/domain/user.dart';

class RoomInfo {
  RoomInfo({
    required this.roomId,
    required this.capacity,
    required this.hostelId,
    required this.roomNumber,
    required this.roomMembers,
    required this.hostelName,
  });
  factory RoomInfo.defaultRoom() {
    return RoomInfo(
      roomId: '',
      capacity: 0,
      hostelId: '',
      hostelName: '',
      roomNumber: '',
      roomMembers: [],
    );
  }
  final String roomId;
  final String hostelId;
  final String hostelName;
  final String roomNumber;
  final int capacity;
  final List<Student?> roomMembers;
  @override
  String toString() {
    return 'RoomInfo(roomId: $roomId, hostelId: $hostelId, roomNumber: $roomNumber, capacity: $capacity, roomMembers: $roomMembers, hostelName: $hostelName)';
  }
}
