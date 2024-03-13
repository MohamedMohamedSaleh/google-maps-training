// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyGoogleMap extends StatefulWidget {
  const MyGoogleMap({
    super.key,
  });

  @override
  State<MyGoogleMap> createState() => _MyGoogleMapState();
}

class _MyGoogleMapState extends State<MyGoogleMap> {
  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  // this controller to controll on map
  final _controller = Completer<GoogleMapController>();
  // i take the markers out to controll on it
  Set<Marker> markers = {
    const Marker(
        markerId: MarkerId('1'), position: LatLng(31.65431312, 31.61434563)),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('google maps'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 400,
              child: GoogleMap(
                  // this onMapCreated when the map is load completed
                  onMapCreated: (controller) {
                    // with this i controll in map
                    _controller.complete(controller);
                  },
                  // this onTap when i click on map
                  onTap: (argument) {
                    markers.add(
                      Marker(
                        markerId: const MarkerId('1'),
                        position: LatLng(argument.latitude, argument.longitude),
                      ),
                    );
                    // i print the latitude and longtude that i click on it
                    print(argument.latitude);
                    print(argument.longitude);
                    setState(() {});
                  },
                  markers: markers,
                  // when map is open show me this position
                  initialCameraPosition: const CameraPosition(
                      target: LatLng(31.65431312, 31.61434563), zoom: 17)),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _goLocation(
              location: const LatLng(31.583685184126903, 30.971242524683475));
          setState(() {});
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _goLocation({required LatLng location}) async {
    // when i wont to move to another place use this algorithm
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location,
          zoom: 14,
        ),
      ),
    );
    // and set the marker in this position
    markers.add(
      Marker(
        markerId: const MarkerId('1'),
        position: location,
      ),
    );
    setState(() {
      
    });
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    var myPosition = await Geolocator.getCurrentPosition();
    _goLocation(location: LatLng(myPosition.latitude, myPosition.longitude));
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return myPosition;
  }
}
