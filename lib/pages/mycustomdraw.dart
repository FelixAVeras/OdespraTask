import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:odespratask/helpers/mycustompaint.dart';

class MyCustomDrawPage extends StatefulWidget {
  @override
  _MyCustomDrawPageState createState() => _MyCustomDrawPageState();
}

class _MyCustomDrawPageState extends State<MyCustomDrawPage> {
  List<Offset> points = [];
  Color selectedColor;
  double strokeWidth;

  @override
  void initState() {
    super.initState();

    selectedColor = Colors.black;
    strokeWidth = 2.0;
  }

  void selectColor() {
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Elegir Color'),
          content: SingleChildScrollView(
            child: BlockPicker(
                pickerColor: selectedColor,
                onColorChanged: (color) {
                  this.setState(() {
                    selectedColor = color;
                  });
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

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color.fromRGBO(17, 32, 168, 1.0),
                  Color.fromRGBO(25, 33, 190, 1.0),
                  Color.fromRGBO(34, 34, 211, 1.0)
                ])),
          ),
          Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                width: customWidth * 0.95,
                height: customHeight * 0.80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 5.0,
                          spreadRadius: 1.0)
                    ]),
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
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: CustomPaint(
                      painter: MyCustomPainter(
                          points: points,
                          color: selectedColor,
                          strokeWidth: strokeWidth),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                width: customWidth * 0.80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  // image: DecorationImage(image: ),
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
                      min: 1.0,
                      max: 8.0,
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
                        })
                  ],
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
