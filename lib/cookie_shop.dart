import 'package:flutter/material.dart';

import 'auto_clicker.dart';

class CookieShop extends StatefulWidget {
  final ValueNotifier<List<AutoClicker>> autoClickersNotifier;
  final Function(AutoClicker) onBuy;

  const CookieShop({Key? key, required this.autoClickersNotifier, required this.onBuy}) : super(key: key);

  @override
  State<CookieShop> createState() => _CookieShopState();
}

class _CookieShopState extends State<CookieShop> {
  @override
  void initState() {
    super.initState();
    widget.autoClickersNotifier.addListener(_onAutoClickersChanged);
  }

  void _onAutoClickersChanged() {
    setState(() {
      // Forces the widget to reload
    });
  }

  @override
  void dispose() {
    widget.autoClickersNotifier.removeListener(_onAutoClickersChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7), // Semi-transparent white
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
              'Power Ups',
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
              key: UniqueKey(),
              itemCount: widget.autoClickersNotifier.value.length,
              itemBuilder: (context, index) {
                AutoClicker autoClicker = widget.autoClickersNotifier.value[index];
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
