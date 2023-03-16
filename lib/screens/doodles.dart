import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'drawing.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../models/doodle_model.dart';
import 'dart:math' show cos, sqrt, asin;

class Doodles extends StatelessWidget {
  Doodles(
      {Key? key,
      required this.data,
      required this.reDraw,
      required this.location})
      : super(key: key);
  Iterable<DoodleModel>? data;
  final void Function(String) reDraw;

  // from stackoverflow:
  // https://stackoverflow.com/questions/54138750/total-distance-calculation-from-latlng-list
  // the function to calculate distance between two geographical points (lat, long)
  // the unit of distance is meters
  double distance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 1000 * 12742 * asin(sqrt(a));
  }

  var userLocation = {"lat": 33.646550843371564, "lng": 72.98992683624948};
  String location = '0, 0';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    const TextStyle usernameStyle =
        TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
    const TextStyle captionStyle =
        TextStyle(fontSize: 14, color: Colors.black54);

    double radius = 25;

    List<String> user = location.split(',');
    double userLat = double.parse(user[0].toString());
    double userLng = double.parse(user[1].toString());

    List<dynamic> doodlesNearby = data!.where((item) {
      List<String> dood = item.location!.split(',');
      double doodLat = double.parse(dood[0].toString());
      double doodLng = double.parse(dood[1].toString());

      double doodleDistance = distance(userLat, userLng, doodLat, doodLng);
      return doodleDistance < radius;
    }).toList();

    return Scaffold(
      body: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              children: [
                Container(),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      children: [
                        for (var doodle in doodlesNearby)
                          Container(
                            width: 300,
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: TextButton(
                              onPressed: () {
                                reDraw(doodle.doodleVectors.toString());
                              },
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.fromLTRB(10, 10, 10, 0)),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.black),
                                  overlayColor: MaterialStateProperty.all(
                                      Color.fromRGBO(0, 0, 0, .05)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ))),
                              child: Column(
                                children: [
                                  DoodlePreview(
                                    vectors: doodle.doodleVectors,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 3),
                                                child: Text(
                                                  doodle.username.toString(),
                                                  style: usernameStyle,
                                                ),
                                              ),
                                              Text(
                                                doodle.description.toString(),
                                                style: captionStyle,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        MdiIcons.cameraIris,
                                        color: Colors.transparent,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
