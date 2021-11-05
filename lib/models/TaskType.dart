import 'dart:convert';

TaskTypeModel taskTypeModelFromJson(String str) =>
    TaskTypeModel.fromJson(json.decode(str));

String taskTypeModelToJson(TaskTypeModel data) => json.encode(data.toJson());

class TaskTypeModel {
  TaskTypeModel({
    this.id,
    this.resultTypeName,
  });

  int id;
  String resultTypeName;

  factory TaskTypeModel.fromJson(Map<String, dynamic> json) => TaskTypeModel(
        id: json["id"],
        resultTypeName: json["resultTypeName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "resultTypeName": resultTypeName,
      };
}
