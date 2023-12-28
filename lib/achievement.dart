class Achievement {
  String name;
  String description;
  int value;
  bool fulfilled;

  Achievement({
    required this.name,
    required this.description,
    required this.value,
    this.fulfilled = false,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      name: json['name'],
      description: json['description'],
      value: json['value'],
    );
  }
}