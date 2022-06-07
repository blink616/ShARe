// import 'package:flutter/material.dart';
// import 'package:user_location/user_location.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';

// import 'package:google_maps_flutter/google_maps_flutter.dart';

// // AIzaSyAxSo-ReVi5az5GmoLlfj50eg6_qohtkfw
// class ARMap extends StatelessWidget {
//   ARMap({Key? key}) : super(key: key);

//   MapController mapController = MapController();
//   List<Marker> markers = [];

//   @override
//   Widget build(BuildContext context) {
//     UserLocationOptions userLocationOptions = UserLocationOptions(
//       context: context,
//       mapController: mapController,
//       markers: markers,
//       updateMapLocationOnPositionChange: false,
//       locationUpdateInBackground: false,
//     );

//     return FlutterMap(
//       options: MapOptions(center: LatLng(51.5, -0.09), zoom: 13.0, plugins: [
//         UserLocationPlugin(),
//       ]),
//       layers: [MarkerLayerOptions(markers: markers), userLocationOptions],
//       children: <Widget>[
//         TileLayerWidget(
//             options: TileLayerOptions(
//                 urlTemplate:
//                     "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                 subdomains: ['a', 'b', 'c'])),
//         MarkerLayerWidget(options: MarkerLayerOptions(markers: markers)),
//       ],
//       mapController: mapController,
//     );
//   }
// }
