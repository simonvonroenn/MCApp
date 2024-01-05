import 'package:flutter/material.dart';
import 'achievement.dart';

/// The view which shows all the achievements
/// after clicking on the achievement icon.
class AchievementsView extends StatefulWidget {
  final ScrollController _scrollController = ScrollController();

  final ValueNotifier<List<Achievement>> achievementsNotifier;

  /// Creates the view with an [achievementsNotifier]
  /// which notifies the view when an achievement has been fulfilled.
  AchievementsView({
    Key? key,
    required this.achievementsNotifier
  }) : super(key: key);

  @override
  State<AchievementsView> createState() => _AchievementViewState();
}

/// The state class for [AchievementsView].
class _AchievementViewState extends State<AchievementsView> {
  @override
  void initState() {
    super.initState();
    widget.achievementsNotifier.addListener(_onAchievementsChanged);
  }

  /// Forces the widget to reload after an achievement has been fulfilled.
  void _onAchievementsChanged() {
    setState(() {
      // Forces the widget to reload
    });
  }

  @override
  void dispose() {
    widget._scrollController.dispose();
    widget.achievementsNotifier.removeListener(_onAchievementsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              controller: widget._scrollController,
              itemCount: widget.achievementsNotifier.value.length,
              itemBuilder: (context, index) {
                Achievement achievement = widget.achievementsNotifier.value[index];
                return _buildAchievementItem(achievement);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the header that says 'Achievements'.
  Container _buildHeader() {
    return Container(
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
    );
  }

  /// Builds an [achievement] item in the list of achievements.
  Padding _buildAchievementItem(Achievement achievement) {
    double screenWidth = MediaQuery.of(context).size.width;
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
  }
}