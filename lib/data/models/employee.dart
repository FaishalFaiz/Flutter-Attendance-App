class Employee {
  final String id;
  final String name;
  final String nik;
  final String position;
  final String department;
  final String shift;
  final String shiftTime;
  final String photoUrl;
  final String email;
  final String phone;
  final String joinDate;

  Employee({
    required this.id,
    required this.name,
    required this.nik,
    required this.position,
    required this.department,
    required this.shift,
    required this.shiftTime,
    required this.photoUrl,
    required this.email,
    required this.phone,
    required this.joinDate,
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
