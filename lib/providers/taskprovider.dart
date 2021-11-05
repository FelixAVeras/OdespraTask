import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

import 'package:odespratask/models/Task.dart';
// import 'package:odespratask/models/TaskType.dart';

class TaskProvider {
  // final String _url = 'https://odesprataskapi.herokuapp.com/api';
  final String _url = 'https://odespratask-default-rtdb.firebaseio.com';

  // Future<List<TaskTypeModel>> loadTaskTypeList() async {
  //   final url = '$_url/task_types';
  //   final resp = await http.get(url);

  //   final Map<int, dynamic> decodedData = json.decode(resp.body);
  //   final List<TaskTypeModel> categories = new List();

  //   if (decodedData == null) {
  //     return [];
  //   }

  //   decodedData.forEach((id, task) {
  //     final taskTypeTemp = TaskTypeModel.fromJson(task);
  //     taskTypeTemp.id = id;

  //     categories.add(taskTypeTemp);
  //   });

  //   return categories;
  // }

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

    // if (resps.statusCode == 200) {
    //   final decodedData = json.decode(resps.body).cast<Map<String, dynamic>>();

    //   List<TaskModel> taskList = decodedData.map<TaskModel>((json) {
    //     return TaskModel.fromJson(json);
    //   }).toList();

    //   return taskList;
    // } else {
    //   throw Exception('Failed to load data from Server.');
    // }

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

    return tareas;
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
