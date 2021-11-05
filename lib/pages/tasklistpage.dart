// import 'package:flutter/material.dart';
// import 'package:odespratask/models/Task.dart';
// import 'package:odespratask/pages/taskdetail.dart';
// import 'package:odespratask/providers/taskprovider.dart';

// class TaskListPage extends StatelessWidget {
//   final taskProvider = new TaskProvider();
//   TaskModel taskModel = new TaskModel();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: _createList());
//   }

//   Widget _createList() {
//     return FutureBuilder(
//       future: taskProvider.loadTaskList(),
//       builder: (BuildContext context, AsyncSnapshot<List<TaskModel>> snapshot) {
//         if (!snapshot.hasData) {
//           return Center(
//               child: Container(
//             padding: EdgeInsets.all(25.0),
//             child: Column(
//               children: [
//                 Text('Cargando Informacion'),
//                 SizedBox(height: 10.0),
//                 LinearProgressIndicator()
//               ],
//             ),
//           ));
//         }

//         return ListView(
//           padding: EdgeInsets.all(8.0),
//           children: snapshot.data
//               .map(
//                 (data) => Column(
//                   children: [
//                     Card(
//                       child: Column(
//                         children: [
//                           (data.image == null)
//                               ? Image(image: AssetImage('assets/no-image.png'))
//                               : FadeInImage(
//                                   placeholder: AssetImage('assets/search.png'),
//                                   image: NetworkImage(data.image)),
//                           ListTile(
//                             title: Text(data.title,
//                                 style: TextStyle(fontSize: 18)),
//                             subtitle: Text(data.description),
//                             trailing: Icon(Icons.arrow_forward_ios),
//                             onTap: () => Navigator.pushNamed(context, 'newtask',
//                                 arguments: taskModel),
//                             // onTap: () => Navigator.push(
//                             //     context,
//                             //     MaterialPageRoute(
//                             //         builder: (context) => TaskDetail(), )),
//                           )
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               )
//               .toList(),
//         );
//       },
//     );

//     // }

//     // Widget _createItemList(BuildContext context, TaskModel model) {
//     //   return ListTile(
//     //     title: Text('$model.titulo'),
//     //     subtitle: Text('$model.descripcion'),
//     //     onTap: () => Navigator.pushNamed(context, 'task'),
//     //   );
//     // }
//   }
// }
