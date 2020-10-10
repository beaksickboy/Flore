import 'package:flutter/material.dart';
import 'dart:math';

/// Random color generator.
///
/// Use the static method [next] to obtain a random [Color]. Alpha is kept
/// constant at 100% opacity.
class RandomColor {

  static final Random _random = new Random();

  /// Returns a random color.
  static Color next() {
    return new Color(0xFF000000 + _random.nextInt(0x00FFFFFF));
  }

}


class RandomColorBlock extends StatefulWidget {
  final double height;
  final double width;
  final Widget child;
  final EdgeInsetsGeometry padding;

  RandomColorBlock({this.width, this.height, this.child, this.padding});

  @override
  _RandomColorBlockState createState() => _RandomColorBlockState();
}

class _RandomColorBlockState extends State<RandomColorBlock> {
  Color color;
  @override
  void initState() {
    super.initState();
    color = RandomColor.next();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      color: color,
      height: widget.height,
      width: widget.width,
      child: widget.child,
    );
  }
}
