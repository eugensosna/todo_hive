import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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
    todoBox =Hive.box<Todo>('todo');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Colors.transparent,
        title: const Text('Todo List'),
      ),
      body: Container(),
      backgroundColor: Color(0xFF1d2630),

    );
  }
}