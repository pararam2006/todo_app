import 'package:flutter/material.dart';
import 'package:todo_app/Todo.dart';

//todo: В КТ4 пригодится
// import 'package:shared_preferences/shared_preferences.dart';

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
  _MyAppState createState() => _MyAppState(); //Сохранение состояния
}

class _MyAppState extends State<MyApp> {

  //todo: В КТ4 пригодится
  // @override
  // void initState() {
  //   super.initState();
  //   _loadData(); // Загрузка данных при инициализации
  // }

  String title = "";
  String text = "";
  int id = 1;
  List<Todo> todoList = [Todo("Это пример задачи", "Создай задачу, нажав кнопку снизу", 0)];

  @override
  Widget build(BuildContext context) {
    // Интерфейс
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
                    decoration: BoxDecoration(
                      // border: Border.all(
                      //   color: Colors.black,
                      //   width: 1
                      // )
                    ),
                    child: Card(
                      child: Column(
                        children: [
                          Text(todoList[index].title, style: TextStyle(fontSize: 22)),
                          Text(todoList[index].text, style: TextStyle(fontSize: 16)),
                        ]
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => _dialogBuilder(context), // Кнопка для вызова диалога
              child: Text("Добавить задачу"),
            ),
          ],
        ),
      ),
    );
  }




  //todo: Оставлю этот блок кода для КТ4, потом внедрю
  // //Загрузка сохраненных данных
  // Future<void> _loadData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     /* todo: Вместо _savedData подгружать распарсенную JSON-строку,
  //        todo: ну или распарсить прямо тут :)
  //      */
  //     // _savedData = prefs.getString('my_key') ?? 'Нет данных'; // Получение данных по ключу
  //   });
  // }
  //
  // //Сохранение данных
  // Future<void> _saveData(String data) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   //todo: Написать сохранение моих данных, а не шляпы из примера
  //   await prefs.setString('my_key', data); // Сохранение данных по ключу
  //   _loadData(); // Загрузка данных после сохранения
  // }

  //Создание диалогового окна
  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Создайте задачу'),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Ограничиваем высоту
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
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Поля не должны быть пустыми!", style: TextStyle(color: Colors.white)),
                      )
                  );
                } else {
                  setState(() {
                    Todo todo = Todo(title, text, id);
                    todoList.add(todo);
                    id++;
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
