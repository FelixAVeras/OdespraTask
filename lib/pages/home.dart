import 'package:flutter/material.dart';
import 'package:odespratask/models/Task.dart';
import 'package:odespratask/providers/taskprovider.dart';

import 'package:provider/provider.dart';

class DrawingArea {
  Offset point;
  Paint areaPaint;

  DrawingArea({this.point, this.areaPaint});
}

class HomePage extends StatefulWidget {
  // final taskProvider = new TaskProvider();
  // context.read<TaskProvider>().loadTaskList();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<TaskProvider>().loadTaskList());
  }

  @override
  Widget build(BuildContext context) {
    final List listTasks = context.watch<TaskProvider>().tasks;
    // context.read<TaskProvider>().loadTaskList();

    return Scaffold(
      appBar: AppBar(
        title: Text('ODESPRA Task'),
        centerTitle: true,
      ),
      body: _taskList(context, listTasks),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'newtask');
        },
        child: Icon(Icons.add),
        tooltip: 'Nueva Tarea',
      ),
    );
  }

  Widget _taskList(BuildContext context, listTasks) {
    return ListView.builder(
        padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
        itemCount: listTasks.length,
        itemBuilder: (context, i) => taskItem(context, listTasks[i]),
        physics: const AlwaysScrollableScrollPhysics());
  }

  Widget taskItem(BuildContext context, TaskModel model) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, 'newtask', arguments: model),
      child: Card(
        child: Row(
          children: [
            Expanded(
                child: (model.image == null)
                    ? Image(image: AssetImage('assets/no-image.png'))
                    : FadeInImage(
                        placeholder: AssetImage('assets/loading.gif'),
                        image: NetworkImage(model.image),
                        height: 150.0,
                        fit: BoxFit.cover)),
            Expanded(
                child: ListTile(
              title: Text('${model.title}'),
              subtitle: Text('${model.description}'),
            ))
          ],
        ),
      ),
    );
  }
}
