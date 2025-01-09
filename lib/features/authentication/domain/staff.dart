class Staff {
  Staff({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.age,
    required this.gender,
    required this.role,
  });
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String age;
  final bool isStaff = true;
  final String gender; // Male porters to male hostels and vice versa.
  final String role; // 'porter', 'admin', etc.
}
