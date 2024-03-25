import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import 'main.dart';
    
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Todo> todoBox;
  @override
  void initState(){
    super.initState();
    todoBox = Hive.box<Todo>('wortshatz');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1d2630),
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.white,
        backgroundColor:  Colors.transparent,
        title: const Text('Todo List'),
      ),
      body: ValueListenableBuilder(
        valueListenable: todoBox.listenable(),
        builder: (context, Box<Todo> box,_) {
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index){
              Todo todo   = box.getAt(index)!;
              return
              GestureDetector(
                onDoubleTap: () {
                  print(todo.title);
                  _editTodoDialog(context, todo, index);
                },

              child:        
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: todo.isCompleted ?Colors.white38: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Dismissible(
                  key: Key(todo.dateTime.toIso8601String()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.amber,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white
                    ),
                  ),
                  onDismissed: (direction){
                    setState(() {

                      todo.delete();
                      //box.delete(todo);
                      //todoBox.delete(todo);
                      //todo.toString();
                    });
                  },
                  child: ListTile(
                    title: Text(todo.title),
                    subtitle:  Text(todo.translate+"-"+ todo.meaning),
                    trailing: Text(todo.translate+"-"+DateFormat.yMMMd().format(todo.dateTime)),
                      leading: Checkbox(
                        
                        value: todo.isCompleted,
                        onChanged: (value){
                        setState(() {
                          
                          todo.isCompleted = value!;
                          todo.save();
                          
                        
                        });
                      },),
                    ),

                    
                )
                )
              );
              });
              }
              ),
              floatingActionButton: FloatingActionButton(
                onPressed:(){
                  _addTodoDialog(context);
                },
                child: const Icon(Icons.add),),
        
      

    );

  }

  void _editTodoDialog(BuildContext context, Todo todo, int indexAt){
    TextEditingController titleController = TextEditingController();
    TextEditingController meanController = TextEditingController();
    TextEditingController descController = TextEditingController();
    TextEditingController transController = TextEditingController();
    titleController.text = todo.title;
    meanController.text = todo.meaning;
    transController.text = todo.translate;
    descController.text = todo.description;

    showDialog(context: context, builder:(context)=>AlertDialog(
      title: const Text("Edit Task") ,
      content: Column(
        
        mainAxisSize: MainAxisSize.min,
        
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: "Title ")
          ),
          TextField(
            controller: descController,
            decoration: const InputDecoration(labelText: "Desvription ")
          ),
          TextField(
            controller: meanController,
            decoration: const InputDecoration(labelText: "Mean ")
          ),
          TextField(
            controller: transController,
            decoration: const InputDecoration(labelText: "Translate ")
          )
        ],),
      actions: [
        TextButton(onPressed:(){
          Navigator.pop(context);
        } 
        , child: const Text("Cancel")),
        TextButton(onPressed:(){
        _editTodo(todo, indexAt, titleController.text, descController.text,
        meanController.text, transController.text);
        Navigator.pop(context);
        } 
        , child: const Text("save"))
      ],
    ));

  }



  void _addTodoDialog(BuildContext context){
    TextEditingController _titleController = TextEditingController();
    TextEditingController _meanController = TextEditingController();
    TextEditingController _descController = TextEditingController();
    TextEditingController _transController = TextEditingController();

    showDialog(context: context, builder:(context)=>AlertDialog(
      title: const Text("Add Task") ,
      content: Column(
        
        mainAxisSize: MainAxisSize.min,
        
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: "Title ")
          ),
          TextField(
            controller: _descController,
            decoration: const InputDecoration(labelText: "Desvription ")
          ),
          TextField(
            controller: _meanController,
            decoration: const InputDecoration(labelText: "Mean ")
          ),
          TextField(
            controller: _transController,
            decoration: const InputDecoration(labelText: "Translate ")
          )
        ],),
      actions: [
        TextButton(onPressed:(){
          Navigator.pop(context);
        } 
        , child: const Text("Cancel")),
        TextButton(onPressed:(){
        _addTodo(_titleController.text, _descController.text,
        _meanController.text, _transController.text);
        Navigator.pop(context);
        } 
        , child: const Text("Add"))
      ],
    ));

  }

  void _addTodo(String title, String description, String meaning, String translate){
    if (title.isNotEmpty){
      todoBox.add(
        Todo(title: title,
         description: description,
         meaning: meaning,
         translate: translate,
          dateTime: DateTime.now())
      );
    
    }
  }



  void _editTodo(Todo todo, int? indexAt,String title, String description, String meaning, String translate){
    todo.title = title;
    todo.description = description;
    todo.meaning =meaning;
    todo.translate = translate;
    
    if (indexAt==null){
      todoBox.add(todo);
           
    }else {
      todoBox.putAt(indexAt, todo);
    }
}
}