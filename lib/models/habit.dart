import 'dart:convert';

class Habit {
  late int? id;
  late String name;
  String? description;
  late String frequency;
  late DateTime startDate;
  late DateTime createdAt;
  late DateTime updatedAt;
  late String status;
  String? imageUrl;
  List<DateTime> completedDays;

  Habit({
    required this.id,
    required this.name,
    this.description,
    required this.frequency,
    required this.startDate,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    this.imageUrl,
    required this.completedDays,
  });

  // Define the copyWith method
  Habit copyWith({
    String? name,
    String? description,
    String? frequency,
    DateTime? startDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? status,
    String? imageUrl,
    List<DateTime>? completedDays,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      completedDays: completedDays ?? this.completedDays,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'frequency': frequency,
      'startDate': startDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'status': status,
      'imageUrl': imageUrl,
      'completedDays': json.encode(completedDays.map((e) => e.toIso8601String()).toList()),
    };
  }

  // Create a Habit object from a Map
  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      frequency: map['frequency'],
      startDate: DateTime.parse(map['startDate']),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      status: map['status'],
      imageUrl: map['imageUrl'],
      completedDays: List<DateTime>.from(
        (json.decode(map['completedDays']) as List).map((e) => DateTime.parse(e)),
      ),
    );
  }
}
