import 'package:flutter/material.dart';

class SlideDots extends StatelessWidget {
  bool isActive;
  SlideDots(this.isActive);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        height: isActive ? 16 : 16,
        width: isActive ? 16 : 16,
        decoration: BoxDecoration(
          color: isActive ? Colors.lightBlue : Colors.blueGrey,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ));
  }
}
