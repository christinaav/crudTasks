# am023_floor_builder

In questo esempio, senza usare *trick* come quelli proposti nell'originale, per creare l'oggetto `TaskDao` ci prepriamo per primo una computazione asincrona
``` dart
Future<TaskDao> _getDao() async {
  final database = await $FloorAppDatabase
    .databaseBuilder('flutter_database.db')
    .build();
  return database.taskDao;
}
```
e quindi 
``` dart
@override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Floor Demo',
      theme: ThemeData(primarySwatch: Colors.red),
      home: FutureBuilder(
        future: _getDao(),
        builder: (BuildContext context, AsyncSnapshot<TaskDao> snapshot) {
        ...
```
Per il `FutureBuiler` [qui](https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html).