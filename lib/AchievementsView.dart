import 'package:flutter/material.dart';
import 'Achievement.dart'; // Importieren Sie die Achievement-Klasse

class AchievementsView extends StatefulWidget {
  final List<Achievement> achievements;

  const AchievementsView({Key? key, required this.achievements}) : super(key: key);

  @override
  _AchievementViewState createState() => _AchievementViewState();
}

class _AchievementViewState extends State<AchievementsView> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ListView.builder(
        itemCount: widget.achievements.length,
        itemBuilder: (context, index) {
          Achievement achievement = widget.achievements[index];
          bool isFulfilled = achievement.fulfilled;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Checkbox Column
                Container(
                  width: screenWidth * 0.25,
                  alignment: Alignment.center,
                  child: Checkbox(
                    value: isFulfilled,
                    onChanged: (bool? value) {},
                  ),
                ),
                // Name and Description Column
                Container(
                  width: screenWidth * 0.75,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        achievement.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16
                        ),
                      ),
                      Text(achievement.description),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}