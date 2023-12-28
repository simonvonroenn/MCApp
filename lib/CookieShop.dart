import 'package:flutter/material.dart';

import 'AutoClicker.dart';

class CookieShop extends StatefulWidget {
  final List<AutoClicker> autoClickers;
  final Function(AutoClicker) onBuy;

  const CookieShop({Key? key, required this.autoClickers, required this.onBuy}) : super(key: key);

  @override
  _CookieShopState createState() => _CookieShopState();
}

class _CookieShopState extends State<CookieShop> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.4,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7), // Semi-transparent white
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ListView.builder(
        key: UniqueKey(),
        itemCount: widget.autoClickers.length,
        itemBuilder: (context, index) {
          AutoClicker autoClicker = widget.autoClickers[index];
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
                          autoClicker.iconPath, width: 80, height: 80),
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
    );
  }
}
