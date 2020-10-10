import 'dart:async';

import 'package:flore/common/widget/random-color-block.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class TrackingMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraint) {
            print(constraint.maxWidth);
            return Stack(
              children: [
                MyMap(),
                Positioned(
                  left: 0,
                  top: 0,
                  width: constraint.maxWidth,
                  height: 150,
                  child: _SearchBox(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class MyMap extends StatefulWidget {
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor _icon;
  Set<Marker> _markers = {};

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.7492742, 106.6472376),
    zoom: 25,
  );

  @override
  void initState() {
    super.initState();
    checkPermissionLocation();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), 'assets/jerry.png')
        .then((icon) {
      _icon = icon;
    });
  }

  void checkPermissionLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.onLocationChanged.listen((event) {
      print(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      markers: _markers,
      initialCameraPosition: _kGooglePlex,

      // circles: {
      //   Circle(
      //
      //   )
      // },
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId("jerry"),
              icon: _icon,
              position: LatLng(10.7491734, 106.6471694),
            ),
          );
        });
      },
    );
  }
}

class _SearchBox extends StatefulWidget {
  @override
  __SearchBoxState createState() => __SearchBoxState();
}

class __SearchBoxState extends State<_SearchBox>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  double offsetHeight = 77;
  double spacing = 20;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 180), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.black12))),
      child: Row(
        children: [
          Expanded(
            child: Placeholder(),
          ),
          Flexible(
            flex: 4,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: LayoutBuilder(
                builder: (context, constraint) {
                  final inputHeight = (constraint.maxHeight - spacing) / 2;
                  print(inputHeight);
                  return AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, _) {
                      return Stack(
                        children: [
                          Positioned(
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "Destination"),
                                  ),
                                ),
                              ],
                            ),
                            width: constraint.maxWidth,
                            height: inputHeight,
                            top: _animationController.value *
                                (inputHeight + spacing),
                          ),
                          Positioned(
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "Pick"),
                                  ),
                                ),
                              ],
                            ),
                            width: constraint.maxWidth,
                            height: inputHeight,
                            top: (inputHeight + spacing) -
                                (_animationController.value *
                                    (inputHeight + spacing)),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Expanded(
            // child: RandomColorBlock(),
            child: Center(
              child: IconButton(
                icon: Icon(
                  Icons.height,
                  color: Colors.black,
                ),
                onPressed: () {
                  switch (_animationController.status) {
                    case AnimationStatus.reverse:
                    case AnimationStatus.dismissed:
                      _animationController.forward();
                      break;
                    case AnimationStatus.forward:
                    case AnimationStatus.completed:
                      _animationController.reverse();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
