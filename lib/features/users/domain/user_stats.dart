/// Application-defined gamification metrics stored on `users/{uid}`.
///
/// Kept in its own type so future gamification features (badges,
/// achievements, leaderboard) can extend without touching the core
/// [AppUser] surface.
class UserStats {
  const UserStats({
    required this.isPremium,
    required this.xp,
    required this.level,
    required this.streak,
    this.lastActiveAt,
  });

  const UserStats.initial()
      : isPremium = false,
        xp = 0,
        level = 1,
        streak = 0,
        lastActiveAt = null;

  /// Whether the user has an active premium entitlement.
  final bool isPremium;

  /// Cumulative experience points earned across the lifetime of the user.
  final int xp;

  /// 1-based progression level. Derived from [xp] but persisted so we can
  /// surface it without recomputing on every read.
  final int level;

  /// Consecutive-day activity streak.
  final int streak;

  /// Last time the user opened the app. May be `null` for freshly created
  /// accounts that have not yet completed a session.
  final DateTime? lastActiveAt;

  static int levelFromXp(int xp) {
    if (xp <= 0) return 1;
    return (xp ~/ 100) + 1;
  }

  UserStats copyWith({
    bool? isPremium,
    int? xp,
    int? level,
    int? streak,
    Object? lastActiveAt = _sentinel,
  }) {
    return UserStats(
      isPremium: isPremium ?? this.isPremium,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      streak: streak ?? this.streak,
      lastActiveAt: identical(lastActiveAt, _sentinel)
          ? this.lastActiveAt
          : lastActiveAt as DateTime?,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is UserStats &&
      other.isPremium == isPremium &&
      other.xp == xp &&
      other.level == level &&
      other.streak == streak &&
      other.lastActiveAt == lastActiveAt;

  @override
  int get hashCode => Object.hash(isPremium, xp, level, streak, lastActiveAt);

  static const Object _sentinel = Object();

  factory UserStats.fromMap(Map<String, dynamic> data) {
    final rawLastActive = data['lastActiveAt'];
    DateTime? lastActive;
    if (rawLastActive is DateTime) {
      lastActive = rawLastActive;
    } else if (rawLastActive is String) {
      lastActive = DateTime.tryParse(rawLastActive);
    } else if (rawLastActive is int) {
      lastActive = DateTime.fromMillisecondsSinceEpoch(rawLastActive);
    }
    return UserStats(
      isPremium: (data['isPremium'] as bool?) ?? false,
      xp: (data['xp'] as int?) ?? 0,
      level: (data['level'] as int?) ?? 1,
      streak: (data['streak'] as int?) ?? 0,
      lastActiveAt: lastActive,
    );
  }

  Map<String, dynamic> toMap() => {
        'isPremium': isPremium,
        'xp': xp,
        'level': level,
        'streak': streak,
        if (lastActiveAt != null) 'lastActiveAt': lastActiveAt!.toIso8601String(),
      };
}
