class Todo {
  String title;
  String text;
  final int id;

  Todo(this.title, this.text, this.id);

  Todo.fromJson(Map<String, dynamic> json)
  : title = json['title'] as String,
    text = json['text'] as String,
    id = json['id'] as int;

  Map<String, dynamic> toJson() => {
    'title' : title,
    'text' : text,
    'id' : id
  };
}

