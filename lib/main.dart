import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/Database/carparkDetail.dart';
import 'package:flutter_application_2/screens/home/home.dart';
import 'package:flutter_application_2/services/auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'models/localUser.dart';
import 'package:flutter_application_2/models/timer.dart';
import 'package:flutter_application_2/models/carparkAPIinit.dart';
import 'package:flutter_application_2/screens/home/landingMap.dart';

///Initialises all the required objects (Initialisation class)
Set<Circle> circles = new Set();
Set<Marker> markers = new Set();
Set<Marker> markersFiltered = new Set();
Set<Marker> markersFinal = new Set();
bool filterState = false;
bool freshStart = true;
bool distState = false;
List<CarparkDetail> carparkObjects = <CarparkDetail>[];
List<CarparkDetail> filteredCarparkObjects = <CarparkDetail>[]; // this is for showing
List<CarparkDetail> filteredCarparkObjectsSaved = <CarparkDetail>[]; // this saves what filter did

bool fullDetail = false;
LatLng point = LatLng(1.348572682702342, 103.68310251054965);

void setMarkers(Set<Marker> marked) {
  markers = marked;
}

/// Initialise firebase to obtain carpark objects from database
void main() async {
  //APItimer;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  carparkObjects = await initCP();
  updateDG(carparkObjects);
  final APItimer = refreshDG(carparkObjects);
  runApp(MyApp());
}

/// Autheticate user
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<LocalUser?>.value(
      catchError: (_, __) => null,
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Home(),
      ),
    );
  }
}
