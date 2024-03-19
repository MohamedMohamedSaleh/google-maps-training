import 'package:flutter/material.dart';
import 'package:google_maps_test/widgets/custom_google_maps.dart';

class GoogleMapTharwat extends StatefulWidget {
  const GoogleMapTharwat({super.key});

  @override
  State<GoogleMapTharwat> createState() => _GoogleMapTharwatState();
}

class _GoogleMapTharwatState extends State<GoogleMapTharwat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: const SizedBox(height: 400, child: CustomGoogleMaps()),
            ),
          ],
        ),
      ),
    );
  }
}
