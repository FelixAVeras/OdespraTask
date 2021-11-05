// To parse this JSON data, do
//
//     final task = taskFromJson(jsonString);

import 'dart:convert';

TaskModel taskFromJson(String str) => TaskModel.fromJson(json.decode(str));

String taskToJson(TaskModel data) => json.encode(data.toJson());

class TaskModel {
  TaskModel({
    this.id,
    this.title = 'Titulo aqui',
    this.description = 'Descripcion aqui',
    this.image,
    this.completed = false,
  });

  String id;
  String title;
  String description;
  String image;
  bool completed;

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        completed: json["completed"],
      );

  Map<String, dynamic> toJson() => {
        // "id": id,
        "title": title,
        "description": description,
        "image": image,
        "completed": completed,
      };
}
