import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mefita/ui/global/helpers/hexcolor.dart';

class InitialsAvatar extends StatelessWidget {
  final String name;
  final double radius;
  final double? fontSize;
  final bool? showBorder;
  final Color? foreColor;
  final Color? backColor;
  const InitialsAvatar({Key? key, required this.name, required this.radius, this.fontSize = 16.0, this.showBorder = false, this.foreColor, this.backColor}) : super(key: key);

  Color generateRandomColor() {
    final random = Random();
    final red = random.nextInt(256);
    final green = random.nextInt(256);
    final blue = random.nextInt(256);
    final opacity = 0.5 + random.nextDouble() * 0.5; // Random opacity between 0.5 and 1.0
    return Color.fromRGBO(red, green, blue, opacity);
  }

  @override
  Widget build(BuildContext context) {
    List<String> initials = name.split(" ").map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase();
      }
      return '';
    }).toList();

    String avatarText = initials.join().substring(0, 2);

    final color = generateRandomColor();
    Color textColor = foreColor ?? HexColor.generateMaterialColor(color.toHex()).shade900;
    Color backgroundColor = backColor ?? HexColor.generateMaterialColor(textColor.toHex()).shade100;
    // final backgroundColor = textColor.withOpacity(0.2);

    return Container(
      decoration: BoxDecoration(
        border: showBorder! ? Border.all(color: textColor.withOpacity(0.3), width: 2) : null,
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        backgroundColor: backgroundColor,
        radius: radius,
        child: Text(
          avatarText,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: fontSize,
            // fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
