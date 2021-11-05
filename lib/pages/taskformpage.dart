import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:odespratask/models/Task.dart';
import 'package:odespratask/providers/taskprovider.dart';

class TaskFormPage extends StatefulWidget {
  TaskFormPage();

  @override
  TaskFormPageState createState() => TaskFormPageState();
}

class TaskFormPageState extends State<TaskFormPage> {
  TaskFormPageState();

  TaskModel taskModel = new TaskModel();
  TaskProvider taskProvider = new TaskProvider();

  bool isComplete = false;
  bool _saving = false;

  final _addFormKey = GlobalKey<FormState>();

  final _titleTaskController = TextEditingController(text: '');
  final _descriptionTaskController = TextEditingController(text: '');

  File imagePhoto;

  @override
  Widget build(BuildContext context) {
    final TaskModel taskData = ModalRoute.of(context).settings.arguments;

    if (imagePhoto != null) {
      Image.file(imagePhoto);
    } else if (taskData != null) {
      taskModel = taskData;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva Tarea'),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.photo_camera_rounded),
        //     onPressed: _takePhoto,
        //     tooltip: 'Usar Camara',
        //   ),
        //   IconButton(
        //     icon: Icon(Icons.photo_rounded),
        //     onPressed: _selectPhoto,
        //     tooltip: 'Usar Galeria',
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: _addFormKey,
            child: Column(
              children: [
                _showPic(),
                SizedBox(height: 20.0),
                _titleInput(),
                SizedBox(height: 20.0),
                _descriptionInput(),
                SizedBox(height: 20.0),
                _choosePic(),
                SizedBox(height: 20.0),
                _completedSwitch(),
                SizedBox(height: 50.0),
                _submitBtn()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _showPic() {
    return imagePhoto != null
        ? Image.file(imagePhoto, fit: BoxFit.cover)
        : Text('No ha seleccionado imagen',
            style: TextStyle(
                fontSize: 18.0,
                color: Colors.deepOrange[300],
                fontWeight: FontWeight.bold));
  }

  Widget _titleInput() {
    return TextFormField(
        // initialValue: taskModel.title,
        controller: _titleTaskController,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(
            labelText: 'Titulo de la tarea', border: OutlineInputBorder()),
        validator: (value) {
          if (value.isEmpty) {
            return 'Por favor ingrese un titulo';
          }
          return null;
        },
        onSaved: (value) => taskModel.title = value);
  }

  Widget _descriptionInput() {
    return TextFormField(
        // initialValue: taskModel.description,
        controller: _descriptionTaskController,
        maxLines: 8,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(
            labelText: 'Descripcion (Opcional)', border: OutlineInputBorder()),
        onSaved: (value) => taskModel.description = value);
  }

  Widget _completedSwitch() {
    return SwitchListTile(
      value: taskModel.completed,
      title: Text('Completada?'),
      onChanged: (value) => setState(() {
        taskModel.completed = value;
      }),
    );
  }

  Widget _choosePic() {
    return OutlinedButton(
        child: Text('Tomar/Selecionar imagen'),
        style: OutlinedButton.styleFrom(
            padding: EdgeInsets.only(left: 60, right: 60, top: 15, bottom: 15)),
        onPressed: () {
          _chooseModalSheet(context);
        });
  }

  void _chooseModalSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    title: Text('Galeria'),
                    onTap: () {
                      ImagePicker().getImage(source: ImageSource.gallery);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  title: Text('Camara'),
                  onTap: () {
                    _takePhoto();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Widget _submitBtn() {
    return RaisedButton(
        onPressed: _submitTask,
        child: Text('Guardar', style: TextStyle(color: Colors.white)),
        color: Colors.indigo,
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 130.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)));
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final imageFile =
        await picker.getImage(source: ImageSource.camera, maxWidth: 300);

    setState(() {
      imagePhoto = File(imageFile.path);
    });
  }

  void _submitTask() async {
    _addFormKey.currentState.save();

    setState(() {
      _saving = true;
    });

    if (imagePhoto != null) {
      taskModel.image = await taskProvider.uploadTaskImage(imagePhoto);
    }

    if (taskModel.id == null) {
      taskProvider.createTask(taskModel);
    } else {
      taskProvider.updateTask(taskModel);
    }

    Navigator.pop(context);
  }
}
