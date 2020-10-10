import 'package:flutter/material.dart';

class CarouselItem extends StatefulWidget {
  final BorderRadiusGeometry borderRadius;
  final BoxShape shape;
  final Gradient gradient;
  final List<BoxShadow> boxShadow;
  final Border border;
  final BoxFit imageBoxFit;
  final EdgeInsets boxPadding;
  final ImageProvider backgroundImage;
  final Widget child;

  CarouselItem(
      {this.backgroundImage,
      this.child,
      this.borderRadius,
      this.shape = BoxShape.rectangle,
      this.boxShadow,
      this.gradient,
      this.border,
      this.imageBoxFit = BoxFit.cover,
      this.boxPadding = const EdgeInsets.all(0.0)});

  @override
  _CarouselItemState createState() => _CarouselItemState();
}

class _CarouselItemState extends State<CarouselItem> {

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(widget.backgroundImage, context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
        shape: widget.shape,
        gradient: widget.gradient,
        boxShadow: widget.boxShadow,
        border: widget.border,
        image: DecorationImage(
          image: widget.backgroundImage,
          fit: widget.imageBoxFit,
        ),
      ),
      child: widget.child,
    );
  }
}
