import 'package:flutter/material.dart';
import 'package:odespratask/pages/home.dart';
import 'package:odespratask/pages/mycustomdraw.dart';
import 'package:odespratask/pages/taskdetail.dart';
import 'package:odespratask/pages/taskformpage.dart';
import 'package:odespratask/providers/taskprovider.dart';
import 'package:provider/provider.dart';
// import 'package:odespratask/pages/tasklistpage.dart';

void main() => runApp(OdespraTask());

class OdespraTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MaterialApp(
        title: 'ODESPRA Task',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.indigo),
        initialRoute: 'home',
        routes: {
          'home': (BuildContext context) => HomePage(),
          // 'task': (BuildContext context) => TaskListPage(),
          'taskdetail': (BuildContext context) => TaskDetail(),
          'newtask': (BuildContext context) => TaskFormPage(),
          'paintingCustom': (BuildContext context) => MyCustomDrawPage()
        },
      ),
    );
  }
}
