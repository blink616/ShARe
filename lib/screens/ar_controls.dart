import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ARControls extends StatelessWidget {
  ARControls({Key? key, required UnityWidgetController unityController})
      : super(key: key);

  late UnityWidgetController unityController;

  @override
  Widget build(BuildContext context) {
    ButtonStyle button = ButtonStyle(
      foregroundColor: MaterialStateProperty.all(Colors.white),
      padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
      overlayColor:
          MaterialStateProperty.all(const Color.fromRGBO(255, 255, 255, .3)),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100.0),
      )),
      // backgroundColor: MaterialStateProperty.all(Colors.grey),
    );

    double iconSize = 30;
    double sliderSize = 2;

    return Container();
  }
}
