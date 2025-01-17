import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Импортируем библиотеку для работы с JSON
import 'package:todo_app/Todo.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text("Список задач")),
      body: MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String title = "";
  String text = "";
  int id = 1;
  List<Todo> todoList = [Todo("Это пример задачи", "Создай задачу, нажав кнопку снизу", 0)];

  @override
  void initState() {
    super.initState();
    _loadData(); // Загрузка данных при инициализации
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Card(
                      child: Column(
                        children: [
                          Text(todoList[index].title, style: TextStyle(fontSize: 22)),
                          Text(todoList[index].text, style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => _dialogBuilder(context),
              child: Text("Добавить задачу"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList = todoList.map((todo) => json.encode(todo.toJson())).toList(); // todoList в json
    await prefs.setStringList('json_todo_list', jsonList); // Сохраняем список JSON-строк
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('json_todo_list'); // Получаем список JSON-строк

    if (jsonList != null) {
      setState(() {
        todoList = jsonList.map((jsonString) => Todo.fromJson(json.decode(jsonString))).toList(); // json в todoList
      });
    }
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Создайте задачу'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (newTitle) {
                  setState(() {
                    title = newTitle;
                  });
                },
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "Заголовок",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (newText) {
                  setState(() {
                    text = newText;
                  });
                },
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "Описание",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Создать'),
              onPressed: () {
                if (title.trim().isEmpty || text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                    Text("Поля не должны быть пустыми!", style: TextStyle(color: Colors.white)),
                  ));
                } else {
                  setState(() {
                    Todo todo = Todo(title, text, id);
                    todoList.add(todo);
                    id++;
                    _saveData(); // Сохраняем данные после добавления задачи
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}