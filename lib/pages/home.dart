import 'package:flutter/material.dart';
import 'package:odespratask/models/Task.dart';
import 'package:odespratask/providers/taskprovider.dart';

class DrawingArea {
  Offset point;
  Paint areaPaint;

  DrawingArea({this.point, this.areaPaint});
}

class HomePage extends StatelessWidget {
  final taskProvider = new TaskProvider();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ODESPRA Task'),
        centerTitle: true,
      ),
      body: _taskList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'newtask');
        },
        child: Icon(Icons.add),
        tooltip: 'Nueva Tarea',
      ),
    );
  }

  Widget _taskList() {
    return FutureBuilder(
        future: taskProvider.loadTaskList(),
        builder:
            (BuildContext context, AsyncSnapshot<List<TaskModel>> snapshot) {
          if (snapshot.hasData) {
            final tasks = snapshot.data;

            return RefreshIndicator(
                child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                    itemCount: tasks.length,
                    itemBuilder: (context, i) => taskItem(context, tasks[i]),
                    physics: const AlwaysScrollableScrollPhysics()),
                onRefresh: () {
                  return Future.delayed(Duration(seconds: 1));
                  () {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: const Text('Lista de tareas actualizada')));
                  };
                });
            // return ListView.builder(
            //     padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
            //     itemCount: tasks.length,
            //     itemBuilder: (context, i) => taskItem(context, tasks[i]));
          } else {
            return Center(
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text('Cargando Informacion...'),
                    SizedBox(height: 10.0),
                    LinearProgressIndicator()
                  ],
                ),
              ),
            );
          }
        });
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
