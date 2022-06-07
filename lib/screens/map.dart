import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/doodle_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ARMap extends StatefulWidget {
  ARMap({Key? key, required this.data}) : super(key: key);
  Iterable<DoodleModel>? data;

  @override
  State<ARMap> createState() => ARMapState();
}

class ARMapState extends State<ARMap> {
  LatLng initPosition =
      const LatLng(0, 0); //initial Position cannot assign null values
  LatLng currentLatLng = const LatLng(
      0.0, 0.0); //initial currentPosition values cannot assign null values
  LocationPermission permission =
      LocationPermission.denied; //initial permission status
  final Completer<GoogleMapController> _controller = Completer();

  final Map<String, Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    checkPermission();
  }

  //checkPersion before initialize the map
  void checkPermission() async {
    permission = await Geolocator.checkPermission();
  }

  // get current location
  void getCurrentLocation() async {
    await Geolocator.getCurrentPosition().then((currLocation) {
      setState(() {
        currentLatLng = LatLng(currLocation.latitude, currLocation.longitude);
      });
    });
  }

  //call this onPress floating action button
  void _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    getCurrentLocation();
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: currentLatLng,
        zoom: 18.0,
      ),
    ));
  }

  //Check permission status and currentPosition before render the map
  bool checkReady(LatLng? x, LocationPermission? y) {
    if (x == initPosition ||
        y == LocationPermission.denied ||
        y == LocationPermission.deniedForever) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(permission);
    print("current: LatLng(" +
        currentLatLng.latitude.toString() +
        ", " +
        currentLatLng.longitude.toString() +
        ")");

    // List<dynamic> doodles = [
    //   {
    //     "id": 1,
    //     "user": "saad_ashraf",
    //     "description": "lorem ipsum dolor sit amet",
    //     "lat": 33.64004938672236,
    //     "lng": 72.98799435951275
    //   },
    //   {
    //     "id": 2,
    //     "user": "naumansamejo",
    //     "description": "C2: lorem ipsum dolor sit amet",
    //     "lat": 33.642888216116596,
    //     "lng": 72.98799306215872
    //   },
    //   {
    //     "id": 3,
    //     "user": "saad_ashraf",
    //     "description": "lorem ipsum dolor sit amet",
    //     "lat": 33.6430309419336,
    //     "lng": 72.98806272917842
    //   },
    //   {
    //     "id": 4,
    //     "user": "hamiz",
    //     "description": "parking: lorem ipsum dolor sit amet",
    //     "lat": 33.64299553066497,
    //     "lng": 72.98976727264551
    //   },
    //   {
    //     "id": 5,
    //     "user": "naumansamejo",
    //     "description": "lorem ipsum dolor sit amet",
    //     "lat": 33.646550843371564,
    //     "lng": 72.98992683624948
    //   },
    // ];

    return MaterialApp(
      //remove debug banner on top right corner
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //ternary operator use for conditional rendering
        body: checkReady(currentLatLng, permission)
            ? const Center(child: CircularProgressIndicator())
            //Stack : place floating action button on top of the map
            : Stack(children: [
                GoogleMap(
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(target: currentLatLng),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    _currentLocation();

                    _markers.clear();
                    int counter = 0;

                    for (var doodle in widget.data!) {
                      List<String> dood = doodle.location!.split(',');
                      double doodLat = double.parse(dood[0].toString());
                      double doodLng = double.parse(dood[1].toString());

                      final _marker = Marker(
                        markerId: MarkerId(counter.toString()),
                        position: LatLng(doodLat, doodLng),
                        infoWindow: InfoWindow(
                          title: doodle.username,
                          snippet: doodle.description,
                        ),
                      );

                      _markers[counter.toString()] = _marker;
                      counter++;
                    }
                  },
                  markers: _markers.values.toSet(),
                ),
                //Positioned : use to place button bottom right corner
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        onPressed: _currentLocation,
                        child: const Icon(MdiIcons.target)),
                  ),
                ),
              ]),
      ),
    );
  }
}
