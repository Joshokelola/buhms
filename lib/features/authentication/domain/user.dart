class Student {
  Student({
    required this.id,
    required this.email,
    required this.level,
    required this.userName,
    required this.matricNumber,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.age,
    required this.gender,
  });

  factory Student.defaultStudent() {
    return Student(
        id: 'id',
        email: 'email',
        level: 'level',
        userName: 'userName',
        matricNumber: 'matricNumber',
        firstName: 'firstName',
        lastName: 'lastName',
        phoneNumber: 'phoneNumber',
        age: 'age',
        gender: 'gender',);
  }

  final String id;
  final String email;
  final String level;
  final String userName;
  final String matricNumber;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String age;
  final String gender;

  //TODO - Incase of serialization issues check here
  final String role = 'user';
  // A staff should be assigned to a particular hostel.
  @override
  String toString() =>
      'Student(id: $id, email: $email, level: $level, username: $userName, matricNumber: $matricNumber, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, age: $age, gender: $gender)';
}
