import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformButton extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color disabledBackgroundColor;
  final BorderRadius borderRadius;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;
  final bool ios;

  PlatformButton({
    Key key,
    @required this.child,
    this.padding,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    @required this.onPressed,
    this.ios = false,
  });

  @override
  Widget build(BuildContext context) {
    return ios
        ? CupertinoButton(
            child: child,
            onPressed: () {},
            color: backgroundColor,
            borderRadius: borderRadius,
            padding: padding,
            disabledColor:
                disabledBackgroundColor ?? CupertinoColors.quaternarySystemFill,
          )
        : RaisedButton(
            child: child,
            onPressed: onPressed,
            disabledColor: disabledBackgroundColor,
            color: backgroundColor,
            padding: padding,
          );
  }
}
