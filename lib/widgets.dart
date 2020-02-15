import 'package:flutter/material.dart';

import 'task.dart';
import 'task_dao.dart';

class ListCell extends StatelessWidget {
  ListCell({
    Key key,
    @required this.task,
    @required this.dao,
  }) : super(key: key);

  final Task task;
  final TaskDao dao;

  @override
  // Widget per l'eliminazione del Task con l'aggiunta degli Alert
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('${task.hashCode}'),
      background: slideRightBackground(),
      secondaryBackground: slideLeftBackground(),
      child: ListTile(
        title: Text(
            "${task.id}: ${task.message}\t\t\t\t\t\trating: ${task.rating}"),
        onTap: () {
          up();
        },
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          final bool res = await showDialog(
              context: context,
              builder: (BuildContext context) {
                // Alert di eliminazione
                return AlertDialog(
                  content: Text("Vuoi eliminare il task?"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        "Annulla",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "Elimina",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        dao.deleteTask(task);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              });
          return res;
        } else {
          // Nel caso il ciccio cambi idea lo riportiamo all'edit
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => editTask(context)));
        }
      },
    );
  }

// Slide inerente alle modifiche del task
// Aggiunta della chiamata a Database : UPDATE
  Widget slideRightBackground() {
    return Container(
      color: Colors.orange,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

// Struttura grafica della cancellazione del Task
  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  void up() async {
    final tasked = Task(task.id, task.message, (task.rating + 1));
    // Chiamata a Database per richiedere l'UPDATE
    await dao.updateTask(tasked);
  }

  TextEditingController _tec = new TextEditingController();

  Widget editTask(context) {
    return Scaffold(
      appBar: AppBar(title: Text("Modifica task")),
      body: Column(
        children: <Widget>[
          Center(
            child: Text(
              "${task.message}",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          TextField(
            controller: _tec,
            decoration: InputDecoration(
              filled: true,
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
              hintText: 'Modifica il task...',
            ),
            onSubmitted: (input) async {
              final message = _tec.text;
              final tasked = Task(task.id, message, task.rating);
              // Modifica del Task richiamando Update per poi ritornare a mostrare la lista aggiornata
              await dao.updateTask(tasked);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
