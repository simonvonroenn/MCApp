import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mc_app/achievements_view.dart';

import 'achievement.dart';
import 'auto_clicker.dart';
import 'cookie_shop.dart';

class CookieHomePage extends StatefulWidget {
  const CookieHomePage({super.key});

  @override
  State<CookieHomePage> createState() => _CookieHomePageState();
}

class _CookieHomePageState extends State<CookieHomePage> {
  bool useEarable = true;
  double _cookieCount = 10000;
  double _cookieSize = 300;
  final double _clickedSize = 330;
  final Duration _animationDuration = const Duration(milliseconds: 50);
  final double _priceIncrement = 1.3;
  final int _headbangBoostIncrement = 2;
  double _headbangBoostPriceIncrement = 2.0;
  double _cookiesPerTick = 0;
  int _headbangBoost = 1;
  int _headbangBoostPrice = 100;
  List<AutoClicker> _autoClickers = [];
  List<Achievement> _achievements = [];
  late ValueNotifier<List<Achievement>> _achievementsNotifier;
  late ValueNotifier<List<AutoClicker>> _autoClickersNotifier;
  late ValueNotifier<int> _headbangBoostNotifier;
  late ValueNotifier<int> _headbangBoostPriceNotifier;

  @override
  void initState() {
    super.initState();
    _headbangBoostNotifier = ValueNotifier<int>(_headbangBoost);
    _headbangBoostPriceNotifier = ValueNotifier<int>(_headbangBoostPrice);
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
      _cookieCount += _headbangBoost;
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
        autoClicker.price = (autoClicker.price.toDouble() * _priceIncrement).toInt();
      });
      _autoClickersNotifier.value = List.from(_autoClickers);
    }
  }

  void _buyHeadbangBoost() {
    if (_cookieCount >= _headbangBoostPrice) {
      setState(() {
        _cookieCount -= _headbangBoostPrice;
        _headbangBoost *= _headbangBoostIncrement;
        _headbangBoostPrice = (_headbangBoostPrice.toDouble() * _headbangBoostPriceIncrement).toInt();
        _headbangBoostPriceIncrement += 0.1 * _headbangBoostPriceIncrement; // Increment the increment
      });
      _headbangBoostNotifier.value = _headbangBoost;
      _headbangBoostPriceNotifier.value = _headbangBoostPrice;
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
              _buildHeader(),
              _buildBody(),
              _buildFooter(),
            ],
          ),
        ],
      ),
    );
  }

  Container _buildHeader() {
    return Container(
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
    );
  }

  Expanded _buildBody() {
    return Expanded(
      child: Center(
        child: GestureDetector(
          onTap: _incrementCookie,
          child: AnimatedContainer(
            duration: _animationDuration,
            width: _cookieSize,
            height: _cookieSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  spreadRadius: 20,
                  blurRadius: 40,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Image.asset('assets/cookie.png'),
          ),
        ),
      ),
    );
  }

  Align _buildFooter() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.white, Colors.white.withOpacity(0)],
          ),
        ),
        child: Stack(
          children: <Widget>[
            _buildAchievementsIcon(),
            _buildEarableSwitch(),
            _buildCookieShopIcon(),
          ],
        ),
      ),
    );
  }

  Positioned _buildAchievementsIcon() {
    return Positioned(
      bottom: 10,
      left: 10,
      child: Column(
        children: [
          Container(
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
          const Text(
            'Achievements',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Positioned _buildEarableSwitch() {
    return Positioned(
      bottom: 20,
      left: MediaQuery.of(context).size.width / 2 - 60,
      child: Container(
        width: 120,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              spreadRadius: 40,
              blurRadius: 40,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Use Earable',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Transform.scale(
              scale: 1.3,
              child: Switch(
                value: useEarable,
                onChanged: (bool value) {
                  setState(() {
                    useEarable = value;
                  });
                },
                activeTrackColor: const Color(0xfffcca4b),
                activeColor: Colors.black87,
                inactiveThumbColor: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Positioned _buildCookieShopIcon() {
    return Positioned(
      bottom: 10,
      right: 10,
      child: Column(
        children: [
          Container(
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
          const Text(
            'Cookie Shop',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.bold,
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
          headbangBoostNotifier: _headbangBoostNotifier,
          headbangBoostPriceNotifier: _headbangBoostPriceNotifier,
          onBuyHeadbangBoost: _buyHeadbangBoost,
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