import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:odespratask/helpers/mycustompaint.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class MyCustomDrawPage extends StatefulWidget {
  final File imagePhoto;

  const MyCustomDrawPage({Key key, this.imagePhoto}) : super(key: key);

  @override
  _MyCustomDrawPageState createState() => _MyCustomDrawPageState();
}

class _MyCustomDrawPageState extends State<MyCustomDrawPage> {
  List<Offset> points = [];
  Color selectedColor;
  double strokeWidth;

  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();

    selectedColor = Colors.black;
    strokeWidth = 2.0;
  }

  void selectColor() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Elegir Color'),
              content: SingleChildScrollView(
                child: BlockPicker(
                    pickerColor: selectedColor,
                    onColorChanged: (color) {
                      this.setState(() {
                        selectedColor = color;
                      });
                      Navigator.of(context).pop();
                    }),
              ),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cerrar'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final double customWidth = MediaQuery.of(context).size.width;
    final double customHeight = MediaQuery.of(context).size.height;

    Future<dynamic> ShowCapturedWidget(
        BuildContext context, Uint8List capturedImage) {
      return showDialog(
        useSafeArea: false,
        context: context,
        builder: (context) => Scaffold(
          body: Center(
              child: capturedImage != null
                  ? Image.memory(capturedImage)
                  : Container()),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color.fromRGBO(217, 217, 217, 1.0),
                  Color.fromRGBO(217, 217, 217, 1.0),
                  Color.fromRGBO(217, 217, 217, 1.0)
                ])),
          ),
          Center(
              child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                    width: customWidth * 0.95,
                    height: customHeight * 0.80,
                    child: Stack(
                      children: [
                        Screenshot(
                            controller: screenshotController,
                            child: Stack(
                              children: [
                                Center(
                                  child: Image.file(widget.imagePhoto),
                                ),
                                Container(
                                  width: customWidth * 0.95,
                                  height: customHeight * 0.80,
                                  child: GestureDetector(
                                    onPanDown: (details) {
                                      this.setState(() {
                                        points.add(details.localPosition);
                                      });
                                    },
                                    onPanUpdate: (details) {
                                      this.setState(() {
                                        points.add(details.localPosition);
                                      });
                                    },
                                    onPanEnd: (details) {
                                      this.setState(() {
                                        points.add(null);
                                      });
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      child: CustomPaint(
                                        painter: MyCustomPainter(
                                            points: points,
                                            color: selectedColor,
                                            strokeWidth: strokeWidth),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    width: customWidth * 0.80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.color_lens,
                              color: selectedColor,
                            ),
                            onPressed: () {
                              selectColor();
                            }),
                        Expanded(
                            child: Slider(
                          min: 2.0,
                          max: 16.0,
                          activeColor: selectedColor,
                          value: strokeWidth,
                          onChanged: (value) {
                            this.setState(() {
                              strokeWidth = value;
                            });
                          },
                        )),
                        IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              this.setState(() {
                                points.clear();
                              });
                            }),
                        IconButton(
                            icon: Icon(Icons.save_rounded),
                            onPressed: () {
                              // screenshotController
                              //     .capture(delay: Duration(milliseconds: 10))
                              //     .then((capturedImage) async {
                              //   ShowCapturedWidget(context, capturedImage);
                              // }).catchError((onError) {
                              //   print(onError);
                              // });

                              screenshotController
                                  .captureAndSave(widget.imagePhoto.path);

                              Navigator.pop(context);
                            })
                      ],
                    ),
                  )
                ],
              )
            ],
          ))
        ],
      ),
    );
  }
}
