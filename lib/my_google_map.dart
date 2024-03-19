// ignore_for_file: avoid_print

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_test/search/bloc/search_bloc.dart';

import 'search/model/search_model.dart';

class MyGoogleMapAmr extends StatefulWidget {
  const MyGoogleMapAmr({
    super.key,
  });

  @override
  State<MyGoogleMapAmr> createState() => _MyGoogleMapAmrState();
}

class _MyGoogleMapAmrState extends State<MyGoogleMapAmr> {
  @override
  void initState() {
    super.initState();

    // _determinePosition();
  }

  String? details;

  // this controller to controll on map
  final _controller = Completer<GoogleMapController>();
  // i take the markers out to controll on it
  Set<Marker> markers = {
    const Marker(
        markerId: MarkerId('1'),
        position: LatLng(31.583685184126903, 30.971242524683475)),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('google maps'),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => SearchBloc(),
        child: Builder(builder: (context) {
          // final bloc = BlocProvider.of<SearchBloc>(context);
          return ListView(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).primaryColor.withOpacity(.03),
                    filled: true,
                    labelText: 'Search',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onFieldSubmitted: (value) async {
                    // bloc.add(SearchEvent(value: value));
                    final response = await Dio().get(
                      'https://api.openrouteservice.org/geocode/search?api_key=5b3ce3597851110001cf62489f19cc96d92e42cab0301b827f94e7d5&text=$value&size=50',
                    );
                    final model = SearchModel.fromJson(response.data);
                    if (!context.mounted) return;
                    showMenu(
                        constraints: BoxConstraints(
                            maxHeight: double.infinity,
                            maxWidth: double.infinity,
                            minHeight: double.infinity,
                            minWidth: double.infinity),
                        context: context,
                        position: const RelativeRect.fromLTRB(30, 200, 16, 16),
                        items: List.generate(
                            model.results.length,
                            (index) => PopupMenuItem(
                                child: Text(model.results[index].lable))));
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 400,
                child: GoogleMap(
                    gestureRecognizers: {}..add(Factory<EagerGestureRecognizer>(
                        () => EagerGestureRecognizer())),
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
                          position:
                              LatLng(argument.latitude, argument.longitude),
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
                        target: LatLng(31.583685184126903, 30.971242524683475),
                        zoom: 9)),
              ),
            ],
          );
        }),
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
    List<Placemark> placemarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    var element = placemarks.first;
    details = "${element.country}/ ${element.name}/ ${element.street}";
    setState(() {});
  }

  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now.
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //   var myPosition = await Geolocator.getCurrentPosition();
  //   _goLocation(location: LatLng(myPosition.latitude, myPosition.longitude));
  //   // When we reach here, permissions are granted and we can
  //   // continue accessing the position of the device.
  //   return myPosition;
  // }
}
