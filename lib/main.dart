import "package:flutter/material.dart";
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive/home_screen.dart';
// import 'package:hive/hive.dart';


@HiveType(typeId:0)
class Todo extends HiveObject {
 @HiveField(0)
 late String title = "";

 @HiveField(1)
 late String description;
 
 @HiveField(2)
 late bool isCompleted;

 @HiveField(3)
  late DateTime dateTime;

  Todo({
    required this.title,
    required this.description,
    required this.dateTime,
    this.isCompleted = false
  });
 
}

class TodoAdapter extends TypeAdapter<Todo> {
  @override
  final typeId = 0;

  @override
  Todo read(BinaryReader reader){
    return Todo(title: reader.readString(),
      description: reader.readString(), 
      isCompleted: reader.readBool(),
      dateTime: DateTime.parse(reader.readString())
    );
  }
   @override
   void write (BinaryWriter writer, Todo obj){
    writer.writeString(obj.title);
    writer.writeString(obj.description);
    writer.writeBool(obj.isCompleted);
    writer.writeString(obj.dateTime.toString());
  }
}

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>("todo");
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Todo Sosna home",
      theme: ThemeData(
        primaryColor: Colors.indigo
      ),
      home: HomeScreen(),
    )  ;              
  }
}
