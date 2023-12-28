import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mc_app/AchievementsView.dart';

import 'Achievement.dart';
import 'AutoClicker.dart';
import 'CookieShop.dart';

class CookieHomePage extends StatefulWidget {
  @override
  _CookieHomePageState createState() => _CookieHomePageState();
}

class _CookieHomePageState extends State<CookieHomePage> {
  double _cookieCount = 0;
  double _cookieSize = 300;
  final double _clickedSize = 330;
  final Duration _animationDuration = const Duration(milliseconds: 50);
  double _cookiesPerTick = 0;
  List<AutoClicker> _autoClickers = [];
  List<Achievement> _achievements = [];
  ValueNotifier<List<Achievement>> _achievementsNotifier = ValueNotifier<List<Achievement>>([]);
  ValueNotifier<List<AutoClicker>> _autoClickersNotifier = ValueNotifier<List<AutoClicker>>([]);


  @override
  void initState() {
    super.initState();
    _loadAutoClickers();
    _loadAchievements();
    Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
      _incrementCookiesAutomatically();
      _checkAchievements();
    });
  }

  Future<void> _loadAutoClickers() async {
    String jsonString = await rootBundle.loadString('assets/auto_clickers.json');
    setState(() {
      _autoClickers = (json.decode(jsonString) as List)
          .map((i) => AutoClicker.fromJson(i))
          .toList();
    });
    _autoClickersNotifier = ValueNotifier<List<AutoClicker>>(_autoClickers);
  }

  Future<void> _loadAchievements() async {
    String jsonString = await rootBundle.loadString('assets/achievements.json');
    setState(() {
      _achievements = (json.decode(jsonString) as List)
          .map((i) => Achievement.fromJson(i))
          .toList();
    });
    _achievementsNotifier = ValueNotifier<List<Achievement>>(_achievements);
  }

  void _incrementCookiesAutomatically() {
    setState(() {
      _cookieCount += _cookiesPerTick;
    });
  }

  void _checkAchievements() {
    for (Achievement achievement in _achievements) {
      if (_cookieCount >= achievement.value && !achievement.fulfilled) {
        achievement.fulfilled = true;
        _achievementsNotifier.value = List.from(_achievements);
      }
    }
  }

  void _incrementCookie() {
    setState(() {
      _cookieCount++;
      _cookieSize = _clickedSize;
    });

    Future.delayed(_animationDuration, () {
      setState(() {
        _cookieSize = 300;
      });
    });
  }

  void _buyAutoClicker(AutoClicker autoClicker) {
    if (_cookieCount >= autoClicker.price) {
      setState(() {
        _cookieCount -= autoClicker.price;
        _cookiesPerTick += autoClicker.cps / 10;
        autoClicker.level++;
      });
      _autoClickersNotifier.value = List.from(_autoClickers);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.black45,
                padding: const EdgeInsets.only(top: 50, bottom: 10, left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text.rich(
                      TextSpan(
                        text: '${_cookieCount.toInt()} Cookies',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32, shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.lightBlueAccent,
                            offset: Offset(0, 0),
                          ),
                        ]),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      '${(_cookiesPerTick * 10).toStringAsFixed(1)} CPS',
                      style: const TextStyle(color: Colors.white, fontSize: 20, shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: Colors.lightBlueAccent,
                          offset: Offset(0, 0),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: _incrementCookie,
                    child: AnimatedContainer(
                      duration: _animationDuration,
                      width: _cookieSize,
                      height: _cookieSize,
                      margin: const EdgeInsets.only(bottom: 100), // Move cookie upwards
                      child: Image.asset('assets/cookie.png'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            bottom: 10,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    spreadRadius: 0,
                    blurRadius: 40,
                  ),
                ],
              ),
              child: IconButton(
                iconSize: 100,
                icon: Image.asset('assets/cookie-shop.png'),
                onPressed: () => _showCookieShop(context),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              decoration: const BoxDecoration(
              shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    spreadRadius: 0,
                    blurRadius: 40,
                  ),
                ],
              ),
              child: IconButton(
                iconSize: 100,
                icon: Image.asset('assets/achievements.png'),
                onPressed: () => _showAchievements(context),
              ),
            ),
         ),
        ],
      ),
    );
  }

  void _showCookieShop(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return CookieShop(
          autoClickersNotifier: _autoClickersNotifier,
          onBuy: (autoClicker) {
            //Navigator.of(context).pop(); // Optional: Closes the shop after purchase
            _buyAutoClicker(autoClicker);
          },
        );
      },
    );
  }

  void _showAchievements(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return AchievementsView(
            achievementsNotifier: _achievementsNotifier
        );
      },
    );
  }
}