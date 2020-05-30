import 'dart:convert';

import 'package:routine/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseTodoService {
  Future<bool> saveTodo(String date, Todo todo);
  // data -> Todo 객체로만들고 -> shared preferences 에 Json으로 저장
  // bool completeTodo();

  Future<TodoList> getTodoList(String date);
  Future<bool> deleteTodo(String date, String todoId);
  Future<bool> updateTodo(String date, Todo todo);
}

class TodoService extends BaseTodoService {
  SharedPref _sharedPreferences = SharedPref();

  // final String _todoKey = "todo_key";
  /*
  {
    todo_date : {
      date : String,
      todos : [
        {
          ...Todo model
        },
        ...
        {
          
        }
      ]
    },
  }
  */

  @override
  // Todo saveTodo(Map<String, dynamic> data) {
  Future<bool> saveTodo(String date, Todo todo) async {
    TodoList todoList = await getTodoList(date);
    todoList.addTodo(todo);
    String jsonTodoList = jsonEncode(todoList.toJson());
    return await this._sharedPreferences.save(date, jsonTodoList);
  }

  @override
  Future<TodoList> getTodoList(String date) async {
    // date 를 key로 해서 저장소에서 Todo List를 가져온다.
    Map<String, dynamic> jsonTodoList =
        jsonDecode(await this._sharedPreferences.read(date));
    TodoList todoList;
    if (jsonTodoList != null) {
      todoList = TodoList.fromJson(jsonTodoList);
    } else {
      todoList = TodoList();
    }
    return todoList;
  }

  @override
  Future<bool> deleteTodo(String date, String todoId) async {
    // TODO: Todo list를 가져온다
    TodoList todoList = await getTodoList(date);
    todoList.todos = todoList.todos.where((e) => e.id != todoId).toList();

    return await _sharedPreferences.save(date, jsonEncode(todoList.toJson()));

    // 받아온 list에서 id와 일치하는 것을 찾아서 저장소에서 제거한다
    // 결과를 리턴한다
  }

  @override
  Future<bool> updateTodo(String date, Todo todo) async {
    TodoList todoList = await getTodoList(date);
    todoList.todos = todoList.todos.map((e) => e.id == todo.id ? todo : e);
    String jsonTodoList = jsonEncode(todoList.toJson());
    return await this._sharedPreferences.save(date, jsonTodoList);
  }
}

class SharedPref {
  Future<dynamic> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final String value = prefs.getString(key);
    return value;
  }

  Future<bool> save(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, value);
  }

  Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }
}
