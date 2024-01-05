/// An achievement within the [AchievementsView].
class Achievement {
  String name;
  String description;
  int value;
  bool fulfilled;

  /// Creates an achievement with
  /// a [name],
  /// a [description],
  /// a [value] (the amount of cookies needed to fulfill the achievement),
  /// and whether the achievement is [fulfilled].
  Achievement({
    required this.name,
    required this.description,
    required this.value,
    this.fulfilled = false,
  });

  /// Creates an achievement from the json file.
  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      name: json['name'],
      description: json['description'],
      value: json['value'],
    );
  }
}