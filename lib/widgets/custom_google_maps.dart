import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMaps extends StatefulWidget {
  const CustomGoogleMaps({super.key});

  @override
  State<CustomGoogleMaps> createState() => _CustomGoogleMapsState();
}

class _CustomGoogleMapsState extends State<CustomGoogleMaps> {
  late GoogleMapController googleMapController;
  late CameraPosition initialCameraPosition;
  Set<Marker> markers = {};
  @override
  void initState() {
    super.initState();
    initMarker();
    initialCameraPosition = const CameraPosition(
        target: LatLng(27.35811230096054, 30.82675897473382), zoom: 4);
    _determinePosition();
  }

  @override
  dispose() {
    super.dispose();
    googleMapController.dispose();
  }

  late BitmapDescriptor customIcon;
  void initMarker() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(15, 30)),
        'assets/images/marker.png');
    // markers.add(
    //   Marker(
    //     icon: customIcon,
    //     infoWindow: const InfoWindow(title: 'ahmed'),
    //     markerId: const MarkerId('1'),
    //     position: const LatLng(31.194587222717363, 29.921865099274914),
    //   ),
    // );
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: GoogleMap(
              onMapCreated: (controller) {
                googleMapController = controller;
              },
              initialCameraPosition: initialCameraPosition,
              markers: markers,
              onTap: (argument) {
                markers.clear();
                markers.add(
                  Marker(
                    icon: customIcon,
                    markerId: const MarkerId('1'),
                    position: LatLng(argument.latitude, argument.longitude),
                  ),
                );
          
                setState(() {});
              },
            ),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        FilledButton(
          onPressed: () {
            googleMapController.animateCamera(
              CameraUpdate.newLatLng(
                const LatLng(31.102527425415566, 29.754741597864932),
              ),
            );
            markers.add(
              Marker(
                icon: customIcon,
                markerId: const MarkerId('1'),
                position: const LatLng(31.102527425415566, 29.754741597864932),
              ),
            );
            setState(() {});
          },
          child: const Text('New position'),
        ),
      ],
    );
  }

  void goToLocation(
      {required double latitude, required double longitude}) async {
    googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(latitude, longitude), 16));
    markers.clear();
    markers.add(
      Marker(
        icon: customIcon,
        markerId: const MarkerId('1'),
        position: LatLng(latitude, longitude),
      ),
    );
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    var myPlace = placemarks.first;
    print('****************************************');
    print(myPlace.country);
    print(myPlace.name);
    print(myPlace.street);
    print(myPlace.administrativeArea);
    print('****************************************');
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location services are disabled'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return Future.error('Location services are disabled');
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

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var myLocation = await Geolocator.getCurrentPosition();
    goToLocation(
        latitude: myLocation.latitude, longitude: myLocation.longitude);
    initialCameraPosition = CameraPosition(
      target: LatLng(myLocation.latitude, myLocation.longitude),
    );
    setState(() {});
    return myLocation;
  }
}
