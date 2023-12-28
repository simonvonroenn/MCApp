import 'package:flutter/material.dart';
import 'achievement.dart';

class AchievementsView extends StatefulWidget {
  final ValueNotifier<List<Achievement>> achievementsNotifier;

  const AchievementsView({Key? key, required this.achievementsNotifier}) : super(key: key);

  @override
  State<AchievementsView> createState() => _AchievementViewState();
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
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.7),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: const Text(
              'Achievements',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
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
                            color: isFulfilled ? Colors.black : Colors.grey,
                            size: 70,
                          )
                      ),
                      // Name and Description Column
                      SizedBox(
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
          ),
        ],
      ),
    );
  }
}