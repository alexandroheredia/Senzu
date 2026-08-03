/// Typed representation of the `users/{uid}` Firestore document.
class AppUser {
  final String uid;
  final String username;
  final String sex;
  final String activityLevel;
  final int dailyCaloriesGoal;

  // --- Personalization (Phase 2) -----------------------------------------
  /// Body metrics, used to compute a suggested calorie goal (BMR/TDEE).
  final double heightCm;
  final double weightKg;
  final int ageYears;

  /// Whether the user completed the first-run onboarding wizard.
  final bool onboardingComplete;

  /// Per-day macro targets in grams. Zero means "not set" (fall back to the
  /// FDA reference values).
  final int proteinGoalG;
  final int carbGoalG;
  final int fatGoalG;

  const AppUser({
    this.uid = '',
    this.username = '',
    this.sex = '',
    this.activityLevel = '',
    this.dailyCaloriesGoal = 0,
    this.heightCm = 0,
    this.weightKg = 0,
    this.ageYears = 0,
    this.onboardingComplete = false,
    this.proteinGoalG = 0,
    this.carbGoalG = 0,
    this.fatGoalG = 0,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, {String uid = ''}) {
    return AppUser(
      uid: uid,
      username: _string(map['username']),
      sex: _string(map['sex']),
      activityLevel: _string(map['activityLevel']),
      dailyCaloriesGoal: _int(map['dailyCaloriesGoal']),
      heightCm: _double(map['heightCm']),
      weightKg: _double(map['weightKg']),
      ageYears: _int(map['ageYears']),
      onboardingComplete: _bool(map['onboardingComplete']),
      proteinGoalG: _int(map['proteinGoalG']),
      carbGoalG: _int(map['carbGoalG']),
      fatGoalG: _int(map['fatGoalG']),
    );
  }

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'username': username,
    'sex': sex,
    'activityLevel': activityLevel,
    'dailyCaloriesGoal': dailyCaloriesGoal,
    'heightCm': heightCm,
    'weightKg': weightKg,
    'ageYears': ageYears,
    'onboardingComplete': onboardingComplete,
    'proteinGoalG': proteinGoalG,
    'carbGoalG': carbGoalG,
    'fatGoalG': fatGoalG,
  };

  AppUser copyWith({
    String? uid,
    String? username,
    String? sex,
    String? activityLevel,
    int? dailyCaloriesGoal,
    double? heightCm,
    double? weightKg,
    int? ageYears,
    bool? onboardingComplete,
    int? proteinGoalG,
    int? carbGoalG,
    int? fatGoalG,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      sex: sex ?? this.sex,
      activityLevel: activityLevel ?? this.activityLevel,
      dailyCaloriesGoal: dailyCaloriesGoal ?? this.dailyCaloriesGoal,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      ageYears: ageYears ?? this.ageYears,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      proteinGoalG: proteinGoalG ?? this.proteinGoalG,
      carbGoalG: carbGoalG ?? this.carbGoalG,
      fatGoalG: fatGoalG ?? this.fatGoalG,
    );
  }
}

String _string(Object? value) => value is String ? value : '';

int _int(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return 0;
}

double _double(Object? value) {
  if (value is num) return value.toDouble();
  return 0;
}

bool _bool(Object? value) => value == true;
