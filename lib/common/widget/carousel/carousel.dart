import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:movie_web/common/layout/carousel/carousel_indicator.dart';
import 'package:movie_web/common/layout/carousel/carousel_item.dart';

class Carousel extends StatefulWidget {
  final List<ParallaxCardModel> items;
  final BorderRadiusGeometry borderRadius;
  final bool showScrollIndicator;
  final double viewPortFraction;
  final BoxShape shape;
  final Gradient gradient;
  final List<BoxShadow> boxShadow;
  final Border border;
  final BoxFit imageBoxFit;
  final EdgeInsets boxPadding;
  final bool infiniteScroll;
  final ScrollPhysics physics;

  Carousel(
      {@required this.items,
      this.borderRadius,
      this.showScrollIndicator = false,
      this.viewPortFraction = 1,
      this.shape = BoxShape.rectangle,
      this.boxShadow,
      this.gradient,
      this.border,
      this.imageBoxFit = BoxFit.cover,
      this.boxPadding = const EdgeInsets.all(0.0),
      this.infiniteScroll = false,
      this.physics = const BouncingScrollPhysics()});

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: widget.viewPortFraction,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          allowImplicitScrolling: true,
          controller: _pageController,
          physics: widget.physics,
          itemBuilder: (context, index) {
            index = index % widget.items.length;
            return Padding(
              padding: widget.boxPadding,
              child: CarouselItem(
                borderRadius: widget.borderRadius,
                shape: widget.shape,
                gradient: widget.gradient,
                boxShadow: widget.boxShadow,
                border: widget.border,
                backgroundImage: widget.items[index].backgroundImage,
                imageBoxFit: widget.imageBoxFit,
                child: widget.items[index].widget,
              ),
            );
          },
          itemCount: widget.infiniteScroll ? null : widget.items.length,
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: CarouselIndicator(
              controller: _pageController,
              size: widget.items.length,
            ),
          ),
        ),
      ],
    );
  }
}

class ParallaxCardModel {
  final ImageProvider backgroundImage;
  final Widget widget;

  ParallaxCardModel({@required this.backgroundImage, @required this.widget});
}
