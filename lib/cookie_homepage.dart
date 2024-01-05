import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mc_app/achievements_view.dart';
import 'package:mc_app/increment_animation.dart';

import 'achievement.dart';
import 'auto_clicker.dart';
import 'cookie_shop.dart';
import 'esense_handler.dart';

/// The main view, which opens on start.
class CookieHomePage extends StatefulWidget {
  const CookieHomePage({super.key});

  @override
  State<CookieHomePage> createState() => _CookieHomePageState();
}

/// The state class for [CookieHomePage].
class _CookieHomePageState extends State<CookieHomePage> with TickerProviderStateMixin {
  final ESenseHandler _eSenseHandler = ESenseHandler();
  bool _useESense = false;
  double _cookieCount = 0;
  final double _cookieSizeInit = 300;
  final double _cookieSizeClicked = 330;
  final Duration _animationDuration = const Duration(milliseconds: 50);
  final double _priceIncrement = 1.3;
  final int _headbangBoostIncrement = 2;
  double _headbangBoostPriceIncrement = 2.0;
  double _cookiesPerTick = 0;
  int _headbangBoost = 1;
  int _headbangBoostPrice = 100;
  List<AutoClicker> _autoClickers = [];
  List<Achievement> _achievements = [];
  final List<IncrementAnimation> _incrementAnimations = [];
  late double _cookieSize = _cookieSizeInit;
  late ValueNotifier<List<Achievement>> _achievementsNotifier;
  late ValueNotifier<List<AutoClicker>> _autoClickersNotifier;
  late ValueNotifier<int> _headbangBoostNotifier;
  late ValueNotifier<int> _headbangBoostPriceNotifier;

  @override
  void initState() {
    super.initState();
    _eSenseHandler.listenToESense();
    _headbangBoostNotifier = ValueNotifier<int>(_headbangBoost);
    _headbangBoostPriceNotifier = ValueNotifier<int>(_headbangBoostPrice);
    _loadAutoClickers();
    _loadAchievements();
    Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
      _incrementCookiesAutomatically();
      _checkAchievements();
      _checkIncrementCookieByHeadbang();
    });
  }

  /// Loads the auto clickers from the json file.
  Future<void> _loadAutoClickers() async {
    String jsonString = await rootBundle.loadString('assets/auto_clickers.json');
    setState(() {
      _autoClickers = (json.decode(jsonString) as List)
          .map((i) => AutoClicker.fromJson(i))
          .toList();
    });
    _autoClickersNotifier = ValueNotifier<List<AutoClicker>>(_autoClickers);
  }

  /// Loads the achievements from the json file.
  Future<void> _loadAchievements() async {
    String jsonString = await rootBundle.loadString('assets/achievements.json');
    setState(() {
      _achievements = (json.decode(jsonString) as List)
          .map((i) => Achievement.fromJson(i))
          .toList();
    });
    _achievementsNotifier = ValueNotifier<List<Achievement>>(_achievements);
  }

  /// Increments the cookies based on the current CPS (cookies per second).
  void _incrementCookiesAutomatically() {
    setState(() {
      _cookieCount += _cookiesPerTick;
    });
  }

  /// Checks whether an achievement has been fulfilled.
  void _checkAchievements() {
    for (Achievement achievement in _achievements) {
      if (_cookieCount >= achievement.value && !achievement.fulfilled) {
        achievement.fulfilled = true;
        _achievementsNotifier.value = List.from(_achievements);
      }
    }
  }

  /// Checks if the user did a headbang and increments the cookie count if so.
  void _checkIncrementCookieByHeadbang() {
    if (_eSenseHandler.isConnected && _useESense) {
      if (_eSenseHandler.incrementDetected) {
        _incrementCookie();
        _eSenseHandler.incrementDetected = false;
      }
    }
  }

  /// Increments the cookie count,
  /// visually displays the amount of cookies added
  /// and lets the cookie increase in size for a short period of time to indicate the click.
  void _incrementCookie() {
    setState(() {
      _cookieCount += _headbangBoost;
      _cookieSize = _cookieSizeClicked;
    });

    _createIncrementAnimation();

    Future.delayed(_animationDuration, () {
      setState(() {
        _cookieSize = _cookieSizeInit;
      });
    });
  }

  /// Buys and auto clicker.
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

  /// Buys a headbang boost,
  /// i.e. a multiplier that increases the amount of cookies gained per click.
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

  /// Visually displays the amount of cookies added after clicking the cookie.
  void _createIncrementAnimation() {
    String value = "+$_headbangBoost";

    final radius = Random().nextInt((_cookieSizeInit / 2 - 50).toInt());
    final angle = Random().nextDouble() * 2 * pi;
    final offset = Offset(cos(angle) * radius, sin(angle) * radius);

    final controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    final animation = Tween(begin: 1.0, end: 0.0).animate(controller);

    controller.forward();

    setState(() {
      _incrementAnimations.add(IncrementAnimation(value: value, controller: controller, fadeOutAnimation: animation, position: offset));
    });

    // Delete animation when finished
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _incrementAnimations.removeAt(0);
        });
      }
    });
  }

  @override
  void dispose() {
    // Dispose all animation controllers
    for (var animation in _incrementAnimations) {
      animation.controller.dispose();
    }
    super.dispose();
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

  /// Builds the header, i.e. the cookie count and the CPS.
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

  /// Builds the body, i.e. the cookie.
  Expanded _buildBody() {
    return Expanded(
      child: Center(
        child: Stack(
          children: [
            GestureDetector(
              onTap: _eSenseHandler.isConnected ? (_useESense ? null : _incrementCookie) : _incrementCookie,
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
            ..._incrementAnimations.map((animation) {
              return Positioned(
                top: _cookieSizeInit / 2 + animation.position.dy,
                left: _cookieSizeInit / 2 + animation.position.dx,
                child: FadeTransition(
                  opacity: animation.fadeOutAnimation,
                  child: Text(
                    animation.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      )
    );
  }

  /// Builds the footer,
  /// i.e. the achievements icon, the switch and the cookie shop icon.
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
            _buildEsenseSwitch(),
            _buildCookieShopIcon(),
          ],
        ),
      ),
    );
  }

  /// Builds the achievements icon.
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

  /// Builds the switch.
  Positioned _buildEsenseSwitch() {
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
              'Use eSense',
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
                value: _eSenseHandler.isConnected ? _useESense : false,
                onChanged: (bool value) {
                  if (_eSenseHandler.isConnected) {
                    if (value) {
                      _eSenseHandler.startListenToSensorEvents();
                    } else {
                      _eSenseHandler.pauseListenToSensorEvents();
                    }
                    setState(() {
                      _useESense = value;
                    });
                  }
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

  /// Builds the cookie shop icon.
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

  /// Shows the cookie shop after clicking on the icon.
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

  /// Shows the achievements view after clicking on the icon.
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