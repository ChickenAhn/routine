import 'package:json_annotation/json_annotation.dart';
import 'package:routine/models/todo.dart';

part 'todo_list.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TodoList {
  TodoList({
    this.id,
    this.date,
    this.todos,
  });

  String id;
  String date;
  List<Todo> todos = [];

  Todo addTodo(Todo newTodo) {
    todos.add(newTodo);
    return newTodo;
  }

  factory TodoList.fromJson(Map<String, dynamic> json) =>
      _$TodoListFromJson(json);

  Map<String, dynamic> toJson() => _$TodoListToJson(this);
}
