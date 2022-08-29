import 'package:flutter/material.dart';

class ColorState extends MaterialStateColor {
  final Color defaultColor;

  final Color pressedColor;

  ColorState({required this.defaultColor, required this.pressedColor})
      : super(defaultColor.value);

  @override
  Color resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      return pressedColor;
    }
    return defaultColor;
  }
}
