
/// Typed representation of the `users/{uid}` Firestore document.
class AppUser {
  final String uid;
  final String username;
  final String sex;
  final String activityLevel;
  final int dailyCaloriesGoal;

  const AppUser({
    this.uid = '',
    this.username = '',
    this.sex = '',
    this.activityLevel = '',
    this.dailyCaloriesGoal = 0,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, {String uid = ''}) {
    return AppUser(
      uid: uid,
      username: _string(map['username']),
      sex: _string(map['sex']),
      activityLevel: _string(map['activityLevel']),
      dailyCaloriesGoal: _int(map['dailyCaloriesGoal']),
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'username': username,
        'sex': sex,
        'activityLevel': activityLevel,
        'dailyCaloriesGoal': dailyCaloriesGoal,
      };

  AppUser copyWith({
    String? uid,
    String? username,
    String? sex,
    String? activityLevel,
    int? dailyCaloriesGoal,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      sex: sex ?? this.sex,
      activityLevel: activityLevel ?? this.activityLevel,
      dailyCaloriesGoal: dailyCaloriesGoal ?? this.dailyCaloriesGoal,
    );
  }
}

String _string(Object? value) => value is String ? value : '';

int _int(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return 0;
}
