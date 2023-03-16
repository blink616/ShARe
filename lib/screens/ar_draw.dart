import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/doodle_model.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'doodles.dart';
import 'ar_controls.dart';

import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ARDraw extends StatefulWidget {
  ARDraw(
      {Key? key,
      required this.data,
      required this.currentUser,
      required this.currentLocation})
      : super(key: key);

  Iterable<DoodleModel>? data;
  String currentUser;
  String currentLocation;

  @override
  State<ARDraw> createState() => _ARDrawState();
}

class _ARDrawState extends State<ARDraw> {
  late UnityWidgetController _unityWidgetController;
  double lineSize = 0.02;
  Iterable<DoodleModel>? doodles;
  String doodle_vectors =
      '{"vectors":{"0":[[-0.13358669,-0.304111332,0.175744444]],"1":[[-0.13358669,-0.304111332,0.175744444]],"2":[[-0.397748351,-0.264259338,0.033952754]],"3":[[-0.397748351,-0.264259338,0.033952754],[-0.397754163,-0.264259279,0.0339498073]],"4":[[-0.386600971,-0.2661934,0.0404551029]],"5":[[-0.386600971,-0.2661934,0.0404551029]],"6":[[-0.386898279,-0.265891761,0.04168322]],"7":[[-0.386898279,-0.265891761,0.04168322]],"8":[[-0.16407834,-0.321790576,0.3934114]],"9":[[-0.16407834,-0.321790576,0.3934114]],"10":[[0.0275543,-0.38622123,-0.000371858478],[0.0275543,-0.38622123,-0.000371858478],[0.0287175532,-0.385304421,9.582937E-05],[0.03067219,-0.3849152,0.0001206398],[0.03181409,-0.385588527,-0.00169099867],[0.0297032371,-0.3882931,-0.00759333372],[0.0281998012,-0.3900962,-0.0112520754],[0.0261285976,-0.392207742,-0.0153341368],[0.0234010965,-0.394507885,-0.01968085],[0.0213635862,-0.396360934,-0.0231529549],[0.019400496,-0.3986304,-0.0274468213],[0.0203353688,-0.400701,-0.03206455],[0.0245133117,-0.402016342,-0.035961628],[0.0295594689,-0.402383149,-0.0380477458],[0.0351450145,-0.401994735,-0.03863632],[0.04192704,-0.400016844,-0.0354643241],[0.0479107872,-0.397167325,-0.0304649472],[0.05261384,-0.3947519,-0.0265322179],[0.05678948,-0.392088354,-0.0219748765],[0.0600306541,-0.38994056,-0.01836896],[0.0618586168,-0.388881624,-0.0168135539],[0.06278034,-0.3885749,-0.0165921673],[0.06341523,-0.38877058,-0.0170752928],[0.06432305,-0.3891657,-0.0182335153],[0.0657626,-0.390333,-0.0216971114],[0.06824334,-0.391973674,-0.02676367],[0.0719489753,-0.3933931,-0.031717442],[0.07763496,-0.393829167,-0.0349434242],[0.08499922,-0.3936638,-0.037087664],[0.09279883,-0.391859531,-0.0355996266],[0.09864065,-0.3897667,-0.03285581],[0.103711545,-0.386048615,-0.0254412964],[0.107591659,-0.382502526,-0.0174361765],[0.110384218,-0.380077,-0.0110370964],[0.110504016,-0.378647625,-0.006287664],[0.109219849,-0.3774093,-0.00157253444],[0.10583739,-0.376958579,0.00181788206],[0.101229265,-0.3767749,0.00478544831],[0.09828073,-0.376307368,0.00765384734],[0.0970778,-0.375089169,0.0116407126]],"11":[[0.172163337,-0.3386129,-0.00022302568],[0.172163337,-0.3386129,-0.00022302568],[0.1728188,-0.337776452,-9.31173563E-05],[0.173193,-0.337198257,1.18613243E-05],[0.172822475,-0.337210268,0.000131621957],[0.170257136,-0.3367676,0.003483057],[0.16705063,-0.337681383,0.00474140048],[0.163508952,-0.3384762,0.00590632856],[0.15935263,-0.339947224,0.0052420646],[0.1541172,-0.342924744,0.00136612356],[0.149681568,-0.345538735,-0.002168849],[0.145498142,-0.34934926,-0.00844796],[0.141946614,-0.3529686,-0.01458548],[0.140287116,-0.357204646,-0.0228602886],[0.142195091,-0.3603484,-0.0304103047],[0.1455563,-0.363173157,-0.03814575],[0.150439575,-0.364517123,-0.04370646],[0.157085687,-0.364359617,-0.04715115],[0.163958371,-0.3628462,-0.04770053],[0.1721389,-0.358929157,-0.0431375131],[0.179058,-0.354489654,-0.0364038274],[0.18408367,-0.350350082,-0.0291289538],[0.187997624,-0.3461606,-0.0211625248],[0.190240562,-0.343173563,-0.0152497739],[0.188665628,-0.340677917,-0.008336484],[0.183329135,-0.3398775,-0.00376415253],[0.176506162,-0.339877427,-0.000294685364],[0.170297146,-0.340239584,0.002243787],[0.167273432,-0.340569615,0.00331026316]],"12":[[0.2319088,-0.310719162,0.00303526223],[0.2319088,-0.310719162,0.00303526223],[0.232462555,-0.310105652,0.00303316116],[0.23011826,-0.31150955,0.00121279061],[0.226673648,-0.314819664,-0.00285354257],[0.222564459,-0.319069058,-0.008447349],[0.219713956,-0.322551668,-0.0135871172],[0.216765121,-0.326225519,-0.0194000453],[0.214012608,-0.329669327,-0.0247228816],[0.211349428,-0.333133578,-0.03042008],[0.210941434,-0.3353874,-0.0354033336],[0.212533712,-0.337031841,-0.0410224572],[0.216369778,-0.3376113,-0.0457668975],[0.220550865,-0.337178737,-0.0479855165],[0.225426286,-0.3354915,-0.0470912158],[0.230859756,-0.332628,-0.04353098],[0.235013962,-0.329857051,-0.03959933],[0.239175469,-0.325814843,-0.0329639241],[0.242018789,-0.323339641,-0.0288451612],[0.243570775,-0.322074175,-0.0269747749],[0.243060812,-0.321993,-0.0265753046],[0.242189735,-0.322216123,-0.0264627784],[0.2408058,-0.322904229,-0.0269857571],[0.239366964,-0.324154973,-0.0289876238],[0.237909675,-0.3258788,-0.0322735757],[0.238100469,-0.327979058,-0.0384116545],[0.240340859,-0.329215765,-0.044603765],[0.245204389,-0.328784525,-0.0489035174],[0.250187069,-0.327864438,-0.0518122166],[0.2541089,-0.326937318,-0.0531740338],[0.2586255,-0.324349582,-0.04979033],[0.2625376,-0.321585119,-0.0449382737],[0.265749484,-0.318616748,-0.0390365869],[0.2696027,-0.3151486,-0.0323935971],[0.273945451,-0.3112604,-0.0247963145],[0.275376618,-0.3087061,-0.0183358938],[0.2762879,-0.305787861,-0.0112093687],[0.274573863,-0.304040819,-0.00575687],[0.2719008,-0.301788837,0.00151669979],[0.2696278,-0.300054,0.00736153126],[0.267213821,-0.299944639,0.009648427]],"13":[[0.328314066,-0.242721051,0.0420298427],[0.328314066,-0.242721051,0.0420298427],[0.327958882,-0.244487286,0.036228627],[0.3265414,-0.246947825,0.03143163],[0.3263072,-0.250051022,0.0265955627],[0.32584852,-0.253832728,0.0212042928],[0.325983077,-0.2573099,0.0156518519],[0.326658159,-0.259711623,0.0111695677],[0.327279061,-0.2622242,0.00586549938],[0.3279943,-0.264931619,-0.0001206696],[0.3277924,-0.268218815,-0.0064509064],[0.326417178,-0.2722472,-0.0133445263],[0.324518055,-0.276551723,-0.0206178725],[0.32286635,-0.280441761,-0.0274689645],[0.321424365,-0.283749819,-0.03352817],[0.320210755,-0.2867869,-0.0395369977],[0.319629341,-0.2888232,-0.0441424921],[0.3188519,-0.29065004,-0.04847791],[0.3184695,-0.291795284,-0.0518154129]],"14":[[0.311965168,-0.300134182,-0.0799171],[0.311965168,-0.300134182,-0.0799171],[0.312044322,-0.299873471,-0.08024164]]}}';
  final int _counter = 0;
  Uint8List? _imageFile;

  List<Color> currentColors = [Colors.yellow, Colors.green];

  void changeColors(List<Color> colors) =>
      setState(() => currentColors = colors);

  // create some values
  Color startColor = Color(0xccffffff);
  Color endColor = Color(0xffffffff);

  bool isRedrawing = false;

  String doodle_description = "lorem ipsum dolor";

// ValueChanged<Color> callback
  void setStartColor(Color color) {
    setState(() => startColor = color);
    syncColor();
  }

  void setEndColor(Color color) {
    setState(() => endColor = color);
    syncColor();
  }

  BorderRadiusGeometry radius = const BorderRadius.only(
    topLeft: Radius.circular(15.0),
    topRight: Radius.circular(15.0),
  );

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();
  PanelController panelController = new PanelController();

  @override
  void dispose() {
    super.dispose();
    _unityWidgetController.dispose();
  }

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

    return Scaffold(
      body: SlidingUpPanel(
        controller: panelController,
        panel: Doodles(
          data: widget.data,
          reDraw: reDraw,
          location: widget.currentLocation,
        ),
        isDraggable: !isRedrawing,
        collapsed: Container(
            decoration:
                BoxDecoration(color: Colors.white, borderRadius: radius),
            child: Column(
              children: [
                Container(
                  height: 3,
                  width: 25,
                  margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(60, 0, 0, 0),
                      borderRadius: BorderRadius.circular(30)),
                ),
                const Center(
                  child: Text(
                    "Explore",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            )),
        body: Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 155),
          child: Stack(
            children: [
              UnityWidget(
                onUnityCreated: _onUnityCreated,
                onUnityMessage: onUnityMessage,
              ),
              Screenshot(
                  child: Stack(
                    children: [
                      Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Stack(
                            children: [
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  alignment: Alignment.bottomLeft,
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    // crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      TextButton(
                                          onPressed: () => {
                                                _unityWidgetController
                                                    .postMessage(
                                                  'LineManager',
                                                  'ClearScreen',
                                                  '',
                                                )
                                              },
                                          child: Icon(
                                            MdiIcons.delete,
                                            size: iconSize,
                                          ),
                                          style: button),
                                      TextButton(
                                          onPressed: () => {
                                                _unityWidgetController
                                                    .postMessage(
                                                  'LineManager',
                                                  'Undo',
                                                  '',
                                                )
                                              },
                                          child: Icon(
                                            MdiIcons.undo,
                                            size: iconSize,
                                          ),
                                          style: button),
                                      Expanded(
                                          child: Center(
                                              child: Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 15),
                                        child: TextButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  title: Text("Share your art"),
                                                  content:
                                                      SingleChildScrollView(
                                                          child: Column(
                                                    children: [
                                                      TextField(
                                                        decoration:
                                                            new InputDecoration(
                                                                hintText:
                                                                    'Description'),
                                                        onChanged: (value) =>
                                                            setState(() {
                                                          doodle_description =
                                                              value;
                                                        }),
                                                      )
                                                    ],
                                                  )),
                                                  actions: <Widget>[
                                                    ElevatedButton(
                                                      child:
                                                          const Text('Cancel'),
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .white),
                                                          foregroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .black)),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    ElevatedButton(
                                                      child: const Text('Done'),
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .black),
                                                          foregroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .white)),
                                                      onPressed: () {
                                                        upload();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            child: const Icon(
                                              Icons.ios_share,
                                              size: 45,
                                              color: Colors.white,
                                            ),
                                            style: button),
                                      ))),
                                      TextButton(
                                          onPressed: () {
                                            _unityWidgetController.postMessage(
                                              'LineManager',
                                              'setTransform',
                                              '0, 0, 0',
                                            );
                                          },
                                          child: Icon(
                                            MdiIcons.plus,
                                            size: iconSize,
                                            color: Colors.white,
                                          ),
                                          style: button),
                                      TextButton(
                                          onPressed: () {
                                            if (isRedrawing) return;

                                            // raise the [showDialog] widget
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                title: Text("Pick a color!"),
                                                content: SingleChildScrollView(
                                                    child: Column(
                                                  children: [
                                                    Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 30, 0, 10),
                                                      child:
                                                          Text("Start Color"),
                                                    ),
                                                    ColorPicker(
                                                      pickerColor: startColor,
                                                      onColorChanged:
                                                          setStartColor,
                                                      pickerAreaBorderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      pickerAreaHeightPercent:
                                                          0.5,
                                                    ),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 30, 0, 10),
                                                      child: Text(
                                                        "End Color",
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    ),
                                                    ColorPicker(
                                                      pickerColor: endColor,
                                                      onColorChanged:
                                                          setEndColor,
                                                      pickerAreaBorderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      pickerAreaHeightPercent:
                                                          0.5,
                                                    ),
                                                  ],
                                                )),
                                                actions: <Widget>[
                                                  ElevatedButton(
                                                    child: const Text('Done'),
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .white),
                                                        foregroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .black)),
                                                    onPressed: () {
                                                      // setState(() =>
                                                      //     currentColor =
                                                      //         pickerColor);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: iconSize,
                                            width: iconSize,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red,
                                                gradient: LinearGradient(
                                                    colors: [
                                                      startColor,
                                                      endColor
                                                    ])),
                                          ),
                                          style: button),
                                    ],
                                  )),
                            ],
                          )),
                      Positioned(
                        right: 0,
                        top: (MediaQuery.of(context).size.height * 0.5) -
                            100 -
                            70,
                        height: 200,
                        child: RotatedBox(
                          quarterTurns: -1,
                          child: SliderTheme(
                            data: const SliderThemeData(
                                thumbShape:
                                    RoundSliderThumbShape(elevation: 10)),
                            child: Slider(
                              value: lineSize,
                              min: 0.009,
                              max: 0.050,
                              onChanged: (val) {
                                _unityWidgetController.postMessage(
                                  'LineManager',
                                  'setLineSize',
                                  val.toString(),
                                );

                                setState(() {
                                  lineSize = val;
                                });
                              },
                              thumbColor: Colors.white,
                              inactiveColor: Colors.white54,
                              activeColor: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  controller: screenshotController),
            ],
          ),
        ),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        maxHeight: 285,
        minHeight: 75,
      ),
      backgroundColor: Colors.black,
    );
  }

  void _onUnityCreated(controller) {
    _unityWidgetController = controller;

    _unityWidgetController.postMessage(
      'LineManager',
      'setLineSize',
      lineSize.toString(),
    );

    syncColor();

    _unityWidgetController.pause();
    Future.delayed(const Duration(seconds: 1), () {
      _unityWidgetController.resume();
    });
  }

  String toRGBA(Color color) {
    String colorString = color.toString();
    colorString = colorString.split("(0x")[1].split(")")[0];
    String alphaHex = colorString.substring(0, 2);
    String colorHex = colorString.substring(2);

    String res = '#' + colorHex + alphaHex;

    return res;
  }

  void syncColor() {
    _unityWidgetController.postMessage(
      'LineManager',
      'setStartColor',
      toRGBA(startColor),
    );

    _unityWidgetController.postMessage(
      'LineManager',
      'setEndColor',
      toRGBA(endColor),
    );

    _unityWidgetController.postMessage(
      'LineManager',
      'setLineSize',
      lineSize.toString(),
    );
  }

  void sendMessage(String message) {
    _unityWidgetController.postMessage(
      'GameManager',
      'Something',
      message,
    );
  }

  bool catchVectors = false;
  void onUnityMessage(message) {
    if (catchVectors) {
      doodle_vectors = message;
      print("catch here");
      catchVectors = false;
    } else {
      print(message);
    }
  }

  void upload() async {
    if (isRedrawing) return;

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    // writing all the values
    catchVectors = true;
    await _unityWidgetController.postMessage(
        'LineManager', 'GetDoodleData', '');

    await Future.delayed(const Duration(milliseconds: 100));

    await firebaseFirestore.collection("doodles").add({
      "username": widget.currentUser,
      "location": widget.currentLocation,
      "doodleVectors": doodle_vectors,
      "description": doodle_description,
    });

    Fluttertoast.showToast(msg: "Doodle Uploaded successfully :) ");
  }

  void reDraw(String vectors) async {
    isRedrawing = true;

    panelController.close();

    final lines = jsonDecode(vectors)["lines"];

    await Future.forEach(lines, (line) async {
      _unityWidgetController.postMessage(
        'LineManager',
        'setStartColor',
        '#' + (line as Map)['startColor'].toString(),
      );

      _unityWidgetController.postMessage(
        'LineManager',
        'setEndColor',
        '#' + (line as Map)['endColor'].toString(),
      );

      _unityWidgetController.postMessage(
        'LineManager',
        'setLineSize',
        (line as Map)['width'].toString(),
      );

      _unityWidgetController.postMessage(
        'LineManager',
        'ReMakeLineRenderer',
        '',
      );

      await Future.forEach((line as Map)["vectors"], (vec) async {
        // if (vec == null) return;
        await Future.delayed(const Duration(milliseconds: 20));

        if (vec == null) return;

        String vecStr = vec.toString().substring(1, vec.toString().length - 1);

        _unityWidgetController.postMessage('LineManager', 'setAnchor', vecStr);

        _unityWidgetController.postMessage(
          'LineManager',
          'DrawLinewContinue',
          '',
        );
      });

      _unityWidgetController.postMessage(
        'LineManager',
        'StopDrawLine',
        '',
      );

      _unityWidgetController.postMessage(
        'LineManager',
        'reStop',
        '',
      );
    });

    syncColor();
    isRedrawing = false;
  }
}

// class ARMain extends StatelessWidget {
//   ARMain({Key? key, required this.data}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ARDraw();
//   }
// }
