import 'package:geolocator/geolocator.dart';

import './screens/loginscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import './screens/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Permission.location.request();

  // runApp(MaterialApp(
  //   home: Home(),
  //   theme: ThemeData(fontFamily: 'JosefinSans'),
  // ));

  // runApp(Container());

  // LocationPermission permission =
  //     LocationPermission.denied; //initial permission status
  // permission = await Geolocator.checkPermission();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Email And Password Login',
      theme: ThemeData(primaryColor: Colors.black, fontFamily: 'JosefinSans'),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
