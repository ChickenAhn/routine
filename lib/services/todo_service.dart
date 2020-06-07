import 'dart:convert';

import 'package:routine/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseTodoService {
  Future<void> updateTodoList(TodoList todoList);
  Future<TodoList> getTodoList();
}

class TodoService extends BaseTodoService {
  SharedPref _sharedPreferences = SharedPref();
  final String _todoListKey = 'my_todo_list';

  @override
  Future<void> updateTodoList(TodoList todoList) async {
    await _sharedPreferences.save(_todoListKey, jsonEncode(todoList.toJson()));
  }

  @override
  Future<TodoList> getTodoList() async {
    String result = await _sharedPreferences.read(_todoListKey);

    if (result != null) {
      return TodoList.fromJson(jsonDecode(result));
    } else {
      return null;
    }
  }
}

class SharedPref {
  Future<String> read(String key) async {
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
