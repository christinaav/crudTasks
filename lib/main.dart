import 'package:flutter/material.dart';

import 'database.dart';
import 'task.dart';
import 'task_dao.dart';
import 'widgets.dart';

main() => runApp(FloorApp());

class FloorApp extends StatelessWidget {
  Future<TaskDao> _getDao() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('database.db').build();
    return database.taskDao;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Floor Demo',
        theme: ThemeData(primarySwatch: Colors.red),
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: _getDao(),
          builder: (BuildContext context, AsyncSnapshot<TaskDao> snapshot) {
            if (snapshot.data != null) {
              final TaskDao dao = snapshot.data;
              return TasksWidget(
                title: 'Task',
                dao: dao,
              );
            } else
              return Container();
          },
        ));
  }
}

class TasksWidget extends StatelessWidget {
  final String title;
  final TaskDao dao;
  final TextEditingController _textEditingController;

  TasksWidget({
    Key key,
    @required this.title,
    @required this.dao,
  })  : _textEditingController = TextEditingController(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: dao.findOrderedTasks(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
                if (!snapshot.hasData) return Container();

                final tasks = snapshot.data;
                // ListView per mostrare tutti i task presenti nella lista
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListCell(
                      task: tasks[index],
                      dao: dao,
                    );
                  },
                );
              },
            ),
          ),
          // TextField usato per aggiungere Task alla lista
          TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              filled: true,
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
              hintText: 'Inserisci un task',
            ),
            onSubmitted: (input) async {
              final message = _textEditingController.text;
              final task = Task(null, message, 0);
              await dao.insertTask(task);
              _textEditingController.clear();
            },
          )
        ],
      ),
    );
  }
}
