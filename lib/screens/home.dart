import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import './doodles.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import './ar_draw.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'map.dart';
import '../models/doodle_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  Iterable<DoodleModel>? doodleData;
  String currentUser = 'NaumanSamejo';

  LocationPermission permission = LocationPermission.denied;
  String location = '0, 0';

  void checkPermission() async {
    permission = await Geolocator.checkPermission();
  }

  void getCurrentLocation() async {
    await Geolocator.getCurrentPosition().then((currLocation) {
      setState(() {
        location = currLocation.latitude.toString() +
            ',' +
            currLocation.longitude.toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      print(loggedInUser.firstName);
      setState(() {
        currentUser = loggedInUser.firstName! + ' ' + loggedInUser.secondName!;
      });
    });

    getData();

    getCurrentLocation();
    checkPermission();

    Timer.periodic(new Duration(seconds: 5), (timer) {
      getData();
      getCurrentLocation();
    });
  }

  Future<void> getData() async {
    CollectionReference _collectionRef = FirebaseFirestore.instance
        .collection('doodles'); // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    setState(() {
      doodleData = allData.map((item) {
        return DoodleModel.fromMap(item);
      });
    });
  }

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      // Doodles(data: doodleData),
      Container(
          padding: EdgeInsets.fromLTRB(0, 120, 0, 50),
          alignment: Alignment.centerLeft,
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Text(
                    currentUser,
                    style: TextStyle(
                      fontSize: 28,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                ),
                SizedBox(
                  height: 1,
                  child: Container(
                    color: Colors.black,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                  child: Text(
                    "Welcome to shARe!\n\nGo to the center tab, start drawing in AR, explore doodles from others, and share as well by writing meaningful description.\n\nDo not misuse the app, be nice to others.",
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          )),
      ARDraw(
        data: doodleData,
        currentUser: currentUser,
        currentLocation: location,
      ),
      ARMap(
        data: doodleData,
      )
    ];

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.informationOutline),
            label: 'Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.draw),
            label: 'AR Draw',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.mapMarker),
            label: 'Explore',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromRGBO(0, 0, 0, 1),
        onTap: _onItemTapped,
        unselectedItemColor: const Color.fromRGBO(0, 0, 0, .3),
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
