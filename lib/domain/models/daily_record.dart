/// daily_record.dart
/// Domain model for daily progress tracking

class DailyRecord {
  final String id;
  final String oderId;
  final DateTime date;
  final bool dawnComplete;
  final bool noonComplete;
  final bool duskComplete;
  final int dawnDefers;
  final int noonDefers;
  final int duskDefers;
  final int pointsEarned;
  final double? milesWalked;
  final int? pushupsCount;
  final int? pullupsCount;
  final int meditationMinutes;
  final bool isPerfectDay;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DailyRecord({
    required this.id,
    required this.oderId,
    required this.date,
    this.dawnComplete = false,
    this.noonComplete = false,
    this.duskComplete = false,
    this.dawnDefers = 0,
    this.noonDefers = 0,
    this.duskDefers = 0,
    this.pointsEarned = 0,
    this.milesWalked,
    this.pushupsCount,
    this.pullupsCount,
    this.meditationMinutes = 0,
    this.isPerfectDay = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from Supabase row
  factory DailyRecord.fromJson(Map<String, dynamic> json) {
    return DailyRecord(
      id: json['id'] as String,
      oderId: json['user_id'] as String,
      date: DateTime.parse(json['date'] as String),
      dawnComplete: json['dawn_complete'] as bool? ?? false,
      noonComplete: json['noon_complete'] as bool? ?? false,
      duskComplete: json['dusk_complete'] as bool? ?? false,
      dawnDefers: json['dawn_defers'] as int? ?? 0,
      noonDefers: json['noon_defers'] as int? ?? 0,
      duskDefers: json['dusk_defers'] as int? ?? 0,
      pointsEarned: json['points_earned'] as int? ?? 0,
      milesWalked: (json['miles_walked'] as num?)?.toDouble(),
      pushupsCount: json['pushups_count'] as int?,
      pullupsCount: json['pullups_count'] as int?,
      meditationMinutes: json['meditation_minutes'] as int? ?? 0,
      isPerfectDay: json['is_perfect_day'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': oderId,
      'date': date.toIso8601String().split('T')[0], // YYYY-MM-DD
      'dawn_complete': dawnComplete,
      'noon_complete': noonComplete,
      'dusk_complete': duskComplete,
      'dawn_defers': dawnDefers,
      'noon_defers': noonDefers,
      'dusk_defers': duskDefers,
      'points_earned': pointsEarned,
      'miles_walked': milesWalked,
      'pushups_count': pushupsCount,
      'pullups_count': pullupsCount,
      'meditation_minutes': meditationMinutes,
      'is_perfect_day': isPerfectDay,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Check if all face-offs are complete
  bool get isComplete => dawnComplete && noonComplete && duskComplete;

  /// Count completed face-offs
  int get completedCount =>
      (dawnComplete ? 1 : 0) + (noonComplete ? 1 : 0) + (duskComplete ? 1 : 0);

  /// Create copy with updates
  DailyRecord copyWith({
    String? id,
    String? userId,
    DateTime? date,
    bool? dawnComplete,
    bool? noonComplete,
    bool? duskComplete,
    int? dawnDefers,
    int? noonDefers,
    int? duskDefers,
    int? pointsEarned,
    double? milesWalked,
    int? pushupsCount,
    int? pullupsCount,
    int? meditationMinutes,
    bool? isPerfectDay,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DailyRecord(
      id: id ?? this.id,
      oderId: userId ?? this.oderId,
      date: date ?? this.date,
      dawnComplete: dawnComplete ?? this.dawnComplete,
      noonComplete: noonComplete ?? this.noonComplete,
      duskComplete: duskComplete ?? this.duskComplete,
      dawnDefers: dawnDefers ?? this.dawnDefers,
      noonDefers: noonDefers ?? this.noonDefers,
      duskDefers: duskDefers ?? this.duskDefers,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      milesWalked: milesWalked ?? this.milesWalked,
      pushupsCount: pushupsCount ?? this.pushupsCount,
      pullupsCount: pullupsCount ?? this.pullupsCount,
      meditationMinutes: meditationMinutes ?? this.meditationMinutes,
      isPerfectDay: isPerfectDay ?? this.isPerfectDay,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
