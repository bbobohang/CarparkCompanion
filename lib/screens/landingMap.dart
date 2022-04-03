// ignore_for_file: unnecessary_new, prefer_const_constructors

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/Database/CoorConverter.dart';
import 'package:flutter_application_2/Database/carparkDetail.dart';
import 'package:flutter_application_2/main.dart' as globals;
import 'package:flutter_application_2/models/localUser.dart';

import 'package:flutter_application_2/screens/FullDetails.dart';
import 'package:flutter_application_2/screens/HalfDetails.dart';
import 'package:geolocator/geolocator.dart';

import 'package:location/location.dart';
import 'package:flutter_application_2/services/auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';

import 'package:flutter_application_2/main.dart';
import 'authenticate/login_or_register.dart';

//for firebase
import "package:firebase_database/firebase_database.dart";
import 'package:firebase_core/firebase_core.dart';

class landingMap extends StatefulWidget {
  const landingMap({Key? key}) : super(key: key);

  @override
  _landingMap createState() => _landingMap();

  // final Position initialPosition;
  // landingMap(this.initialPosition);
}

class _landingMap extends State<landingMap> {
  Set<Marker> markers = new Set();
  int id = 0;
  late Position _currentPosition;
  final AuthService _auth = AuthService();

  Set<Marker> markers2 = new Set();
  List<carparkDetail> carparkObjects2 = <carparkDetail>[];

  //Location is to obtain live location of user
  Location _location = new Location();
  late GoogleMapController _controller;

  void _onMapCreated(GoogleMapController _cntlr) {
    var _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
        ),
      );
    });
  }

  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    Geolocation? geolocation;

    //User is to check if the user is logged in
    final user = Provider.of<LocalUser?>(context);

    //To make code more efficient, can create 2 classes, 1 for login, 1 for not logged in

    if (user == null) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Map"),
            backgroundColor: Color.fromARGB(255, 20, 27, 66),
            elevation: 0.0,
            actions: <Widget>[
              ElevatedButton.icon(
                icon: const Icon(Icons.person),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 20, 27, 66),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginOrRegsiter()));
                },
                label: const Text('Log In'),
              )
            ],
          ),
          body: Container(
              child: SingleChildScrollView(
                  child: Column(
            children: [
              SearchMapPlaceWidget(
                  bgColor: Color.fromARGB(255, 246, 245, 244),
                  hasClearButton: true,
                  placeType: PlaceType.address,
                  placeholder: 'Enter the location',
                  textColor: Color.fromARGB(255, 14, 13, 13),
                  apiKey: 'AIzaSyAUvR8wEIPEudD_xfJ6BpGx02vKoohOn5M',
                  onSelected: (Place place) async {
                    geolocation = await place.geolocation;
                    mapController.animateCamera(
                        CameraUpdate.newLatLng(geolocation?.coordinates));
                    mapController.animateCamera(
                        CameraUpdate.newLatLngBounds(geolocation?.bounds, 0));
                    print("Chosen location: " + geolocation.toString());
                  }),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: SizedBox(
                  height: 490.0,
                  child: GoogleMap(
                    onMapCreated: (GoogleMapController googleMapController) {
                      setState(() {
                        mapController = googleMapController;
                      });
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(1.348572682702342, 103.68310251054965),
                      zoom: 15.0,
                    ),
                    /*onMapCreated: _onMapCreated,*/
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    markers: globals.markers,
                  ),
                ),
              ),
            ],
          ))));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Map"),
            backgroundColor: Color.fromARGB(255, 20, 27, 66),
            elevation: 0.0,
            actions: <Widget>[
              ElevatedButton.icon(
                icon: const Icon(Icons.person),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 20, 27, 66),
                ),
                onPressed: () async {
                  await _auth.signOut();
                },
                label: const Text('Log Out'),
              )
            ],
          ),
          body: Container(
              child: SingleChildScrollView(
                  child: Column(
            children: [
              SearchMapPlaceWidget(
                  bgColor: Color.fromARGB(255, 246, 245, 244),
                  hasClearButton: true,
                  placeType: PlaceType.address,
                  placeholder: 'Enter the location',
                  textColor: Color.fromARGB(255, 14, 13, 13),
                  apiKey: 'AIzaSyAUvR8wEIPEudD_xfJ6BpGx02vKoohOn5M',
                  onSelected: (Place place) async {
                    geolocation = await place.geolocation;
                    mapController.animateCamera(
                        CameraUpdate.newLatLng(geolocation?.coordinates));
                    mapController.animateCamera(
                        CameraUpdate.newLatLngBounds(geolocation?.bounds, 0));
                    print("Chosen location: " + geolocation.toString());
                  }),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: SizedBox(
                  height: 490.0,
                  child: GoogleMap(
                    onMapCreated: (GoogleMapController googleMapController) {
                      setState(() {
                        mapController = googleMapController;
                      });
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(1.348572682702342, 103.68310251054965),
                      zoom: 15.0,
                    ),
                    /*onMapCreated: _onMapCreated,*/
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    markers: globals.markers,
                  ),
                ),
              ),
            ],
          ))));
    }
  }
}
