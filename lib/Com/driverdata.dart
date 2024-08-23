class Driver {
  final String id;
  final String name;
  final String phone;

  Driver({required this.id, required this.name, required this.phone});

  factory Driver.fromMap(Map<dynamic, dynamic> map) {
    return Driver(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
    );
  }
}
