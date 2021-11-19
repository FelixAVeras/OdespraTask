import 'dart:convert';
import 'dart:io';

// import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

import 'package:odespratask/models/Task.dart';
// import 'package:odespratask/models/TaskType.dart';

import 'package:provider/provider.dart';

class TaskProvider with ChangeNotifier {
  // final String _url = 'https://odesprataskapi.herokuapp.com/api';
  final String _url = 'https://odespratask-default-rtdb.firebaseio.com';

  List _tasks;

  List get tasks => _tasks;

  Future<bool> createTask(TaskModel model) async {
    final url = '$_url/Task.json';

    final resp = await http.post(url, body: taskToJson(model));
    final decodeData = json.decode(resp.body);

    print(decodeData);

    return true;
  }

  Future<bool> updateTask(TaskModel model) async {
    final url = '$_url/Task/${model.id}.json';

    final resp = await http.put(url, body: taskToJson(model));
    final decodeData = json.decode(resp.body);

    print(decodeData);

    return true;
  }

  Future<List<TaskModel>> loadTaskList() async {
    final taskUrl = '$_url/Task.json';
    final resps = await http.get(taskUrl);

    final Map<String, dynamic> decodedData = json.decode(resps.body);
    final List<TaskModel> tareas = new List();

    if (decodedData == null) {
      return [];
    }

    decodedData.forEach((id, tsk) {
      final tareaTemp = TaskModel.fromJson(tsk);
      tareaTemp.id = id;

      tareas.add(tareaTemp);
    });

    _tasks = tareas;

    notifyListeners();
    return tasks;
  }

  Future<String> uploadTaskImage(File taskImage) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/drbon78ay/image/upload?upload_preset=fsy57dxn');
    final mimetype = mime(taskImage.path).split('/');
    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file', taskImage.path,
        contentType: MediaType(mimetype[0], mimetype[1]));

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo anda mal...');
      print(resp.body);

      return null;
    }

    final finalResult = json.decode(resp.body);

    return finalResult['secure_url'];
  }
}
