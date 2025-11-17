import 'package:uuid/uuid.dart';

class Task {
  final String id;
  String title;
  String description;
  bool isCompleted;
  DateTime createdAt;
  DateTime? completedAt;
  int? timeSpentMinutes;

  Task({
    String? id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    DateTime? createdAt,
    this.completedAt,
    this.timeSpentMinutes,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'timeSpentMinutes': timeSpentMinutes,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      timeSpentMinutes: json['timeSpentMinutes'],
    );
  }

  Task copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? completedAt,
    int? timeSpentMinutes,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
      completedAt: completedAt ?? this.completedAt,
      timeSpentMinutes: timeSpentMinutes ?? this.timeSpentMinutes,
    );
  }
}
