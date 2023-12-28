class AutoClicker {
  String name;
  double cps;
  int price;
  String iconPath;
  int level = 0;

  AutoClicker({
    required this.name,
    required this.cps,
    required this.price,
    required this.iconPath,
  });

  factory AutoClicker.fromJson(Map<String, dynamic> json) {
    return AutoClicker(
      name: json['name'],
      cps: json['cps'],
      price: json['price'],
      iconPath: json['iconPath'],
    );
  }
}