import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@RoutePage()
class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  // in the below line, we are initializing our controller for google maps.
  final Completer<GoogleMapController> _controller = Completer();

  final location = LatLng(27.686386, 83.432426);

  // in the below line, we are specifying our camera position
  static final CameraPosition _kNepal = const CameraPosition(
    target: LatLng(27.686386, 83.432426),
    zoom: 22,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // in the below line, we are specifying our app bar.
      appBar: AppBar(title: Text("Location Page")),
      body: GoogleMap(
        // in the below line, setting camera position
        initialCameraPosition: _kNepal,
        markers: {
          Marker(
            markerId: MarkerId("first_marker"),
            draggable: true,
            onDragEnd: (value) {},
            position: location,
            infoWindow: InfoWindow(title: 'Title of this marker'),
          ),
        },

        // in the below line, setting user location enabled.
        // myLocationEnabled: true,
        // in the below line, setting compass enabled.
        compassEnabled: true,
        // in the below line, specifying controller on map complete.
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
