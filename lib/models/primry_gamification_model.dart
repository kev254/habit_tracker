import 'dart:convert';

class Gamifications {
  final int id, userId, xp, level, streak;
  final String badges, createdAt, updatedAt;

  Gamifications({
    required this.id,
    required this.userId,
    required this.xp,
    required this.level,
    required this.badges,
    required this.createdAt,
    required this.updatedAt,
    required this.streak,
  });

  factory Gamifications.fromJson(Map<String, dynamic> json) {
    return Gamifications(
      id: json['id'],
      userId: json['user_id'],
      xp: json['xp'],
      level: json['level'],
      badges: json['badges'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      streak: json['streak'],
    );
  }
}

class Progress {
  final int id, habitId;
  final String progressDate, status, createdAt, updatedAt;

  Progress({
    required this.id,
    required this.habitId,
    required this.progressDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      id: json['id'],
      habitId: json['habit_id'],
      progressDate: json['progress_date'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Habit {
  final String habitName, startDate, description, frequency, status;
  final int userId;
  final List<Progress> progress;

  Habit({
    required this.habitName,
    required this.startDate,
    required this.description,
    required this.frequency,
    required this.status,
    required this.userId,
    required this.progress,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      habitName: json['habit_name'],
      startDate: json['start_date'],
      description: json['description'],
      frequency: json['frequency'],
      status: json['status'],
      userId: json['user_id'],
      progress: (json['progress'] as List)
          .map((progressJson) => Progress.fromJson(progressJson))
          .toList(),
    );
  }
}

class PrimryGamificationModel {
  final Gamifications userGamifications;
  final List<Habit> habits;

  PrimryGamificationModel({
    required this.userGamifications,
    required this.habits,
  });

  factory PrimryGamificationModel.fromJson(Map<String, dynamic> json) {
    return PrimryGamificationModel(
      userGamifications:
      Gamifications.fromJson(json['user_gamifications']),
      habits: (json['habits'] as List)
          .map((habitJson) => Habit.fromJson(habitJson))
          .toList(),
    );
  }
}
