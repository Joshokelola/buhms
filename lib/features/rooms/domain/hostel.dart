class Hostel {
  Hostel({required this.id, required this.hostelName, required this.gender});

  final String id;
  final String hostelName;
  final String gender;

  @override
  String toString() => 'Hostel(id: $id, hostelName: $hostelName, gender: $gender)';
}
