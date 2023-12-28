import 'package:flutter/material.dart';
import 'Achievement.dart';

class AchievementsView extends StatefulWidget {
  final ValueNotifier<List<Achievement>> achievementsNotifier;

  const AchievementsView({Key? key, required this.achievementsNotifier}) : super(key: key);

  @override
  _AchievementViewState createState() => _AchievementViewState();
}

class _AchievementViewState extends State<AchievementsView> {
  @override
  void initState() {
    super.initState();
    widget.achievementsNotifier.addListener(_onAchievementsChanged);
  }

  void _onAchievementsChanged() {
    setState(() {
      // Forces the widget to reload
    });
  }

  @override
  void dispose() {
    widget.achievementsNotifier.removeListener(_onAchievementsChanged);
    super.dispose();
  }

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
        itemCount: widget.achievementsNotifier.value.length,
        itemBuilder: (context, index) {
          Achievement achievement = widget.achievementsNotifier.value[index];
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
                  child: Icon(
                      isFulfilled ? Icons.check_circle : Icons.circle_rounded,
                    color: isFulfilled ? Colors.green : Colors.grey,
                    size: 50,
                  )
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