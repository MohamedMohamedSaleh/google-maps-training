import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_test/google_map_tharwat.dart';
import 'package:google_maps_test/search/bloc/search_bloc.dart';
import 'package:google_maps_test/services/bloc/get_address_bloc.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => SearchBloc(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
      create: (BuildContext context) => GetAddressBloc(),)

        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Goolge Map',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const GoogleMapTharwat(),
        ),
      ),
    );
  }
}
