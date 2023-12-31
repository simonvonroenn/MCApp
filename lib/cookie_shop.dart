import 'package:flutter/material.dart';

import 'auto_clicker.dart';

/// The view which shows the cookie shop
/// where the user can buy auto clickers and headbang boosts
/// after clicking on the icon.
class CookieShop extends StatefulWidget {
  final ScrollController _scrollController = ScrollController();

  final ValueNotifier<List<AutoClicker>> autoClickersNotifier;
  final Function(AutoClicker) onBuy;
  final ValueNotifier<int> headbangBoostNotifier;
  final ValueNotifier<int> headbangBoostPriceNotifier;
  final Function onBuyHeadbangBoost;

  /// Creates the cookie shop with
  /// an [autoClickersNotifier] which contains the auto clickers
  /// and updates the view if an auto clicker has been bought,
  /// an [onBuy] method that is called to buy an auto clicker,
  /// a [headbangBoostNotifier] that holds the current headbang boost
  /// and notifies when it changes,
  /// a [headbangBoostPriceNotifier] that holds the current headbang boost price
  /// and notifies when it changes
  /// and a [onBuyHeadbangBoost] method that is called to buy a headbang boost.
  CookieShop({
    Key? key,
    required this.autoClickersNotifier,
    required this.onBuy,
    required this.headbangBoostNotifier,
    required this.headbangBoostPriceNotifier,
    required this.onBuyHeadbangBoost,
  }) : super(key: key);

  @override
  State<CookieShop> createState() => _CookieShopState();
}

/// The state class for [CookieShop].
class _CookieShopState extends State<CookieShop> {
  @override
  void initState() {
    super.initState();
    widget.autoClickersNotifier.addListener(_onChange);
    widget.headbangBoostNotifier.addListener(_onChange);
    widget.headbangBoostPriceNotifier.addListener(_onChange);
  }

  /// Forces the widget to reload after an auto clicker or boost has been bought.
  void _onChange() {
    setState(() {
      // Forces the widget to reload
    });
  }

  @override
  void dispose() {
    widget._scrollController.dispose();
    widget.autoClickersNotifier.removeListener(_onChange);
    widget.headbangBoostNotifier.removeListener(_onChange);
    widget.headbangBoostPriceNotifier.removeListener(_onChange);
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
              itemCount: widget.autoClickersNotifier.value.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildHeadbangBoostItem();
                } else {
                  AutoClicker autoClicker = widget.autoClickersNotifier.value[index - 1];
                  return _buildAutoClickerItem(autoClicker);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the header that says 'Power Ups'.
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
        'Power Ups',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Builds the headbang boost item in the list of power ups.
  Padding _buildHeadbangBoostItem() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: () => widget.onBuyHeadbangBoost(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // First Column: Headbang Icon
            Container(
              width: screenWidth * 0.25,
              alignment: Alignment.center,
              child: Image.asset('assets/headbang-boost.png', width: 70, height: 70),
            ),
            // Second Column: Name and Price
            Container(
              width: screenWidth * 0.50,
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Headbang Boost',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${widget.headbangBoostPriceNotifier.value} Cookies',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              width: screenWidth * 0.25,
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Boost:'),
                  Text('${widget.headbangBoostNotifier.value}x'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds an [autoClicker] item in the list of power ups.
  Padding _buildAutoClickerItem(AutoClicker autoClicker) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
          onTap: () => widget.onBuy(autoClicker),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // First Column: Icon
              Container(
                width: screenWidth * 0.25,
                alignment: Alignment.center,
                child: Image.asset(
                    autoClicker.iconPath, width: 70, height: 70),
              ),
              // Second Column: Name and Price
              Container(
                width: screenWidth * 0.50,
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      autoClicker.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${autoClicker.price} Cookies',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // Third Column: Level and CPS
              Container(
                width: screenWidth * 0.25,
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Level: ${autoClicker.level}'),
                    Text('CPS: ${autoClicker.cps}'),
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }
}
