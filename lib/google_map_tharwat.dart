import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_test/services/bloc/get_address_bloc.dart';
import 'package:google_maps_test/widgets/custom_google_maps.dart';

class GoogleMapTharwat extends StatefulWidget {
  const GoogleMapTharwat({super.key});

  @override
  State<GoogleMapTharwat> createState() => _GoogleMapTharwatState();
}

class _GoogleMapTharwatState extends State<GoogleMapTharwat> {
  late GetAddressBloc bloc;
  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of(context);
  }

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
            FilledButton(
              onPressed: () {
                bloc.add(GetAddressEvent());
              },
              child: const Text('Address'),
            ),
          ],
        ),
      ),
    );
  }
}
