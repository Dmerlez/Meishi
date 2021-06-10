import 'package:flutter/material.dart';

class BadgeIcon extends StatelessWidget {
  final Widget icon;
  final int badgeCount;
  final bool showIfZero;
  final Color badgeColor;
  final TextStyle badgeTextStyle;

  BadgeIcon(
      {this.icon,
      this.badgeCount = 0,
      this.showIfZero = true,
      this.badgeColor = Colors.red,
      TextStyle badgeTextStyle})
      : this.badgeTextStyle =
            badgeTextStyle ?? TextStyle(color: Colors.white, fontSize: 8);

  Widget build(BuildContext context) {
    return new Stack(children: <Widget>[
      icon,
      if (badgeCount > 0 || showIfZero) badge(badgeCount),
    ]);
  }

  Widget badge(int count) => Positioned(
      right: 0,
      top: 0,
      child: Container(
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(8.5),
          ),
          constraints: BoxConstraints(minHeight: 15, minWidth: 15),
          child: Text(
            count.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          )));
}
