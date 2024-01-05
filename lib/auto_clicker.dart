/// An auto clicker that can be bought in the [CookieShop].
class AutoClicker {
  String name;
  double cps;
  int price;
  String iconPath;
  int level = 0;

  /// Creates an auto clicker with
  /// a [name], the [cps] cookies per second, the [price] and the [iconPath].
  AutoClicker({
    required this.name,
    required this.cps,
    required this.price,
    required this.iconPath,
  });

  /// Creates an auto clicker from the json file.
  factory AutoClicker.fromJson(Map<String, dynamic> json) {
    return AutoClicker(
      name: json['name'],
      cps: json['cps'],
      price: json['price'],
      iconPath: json['iconPath'],
    );
  }
}