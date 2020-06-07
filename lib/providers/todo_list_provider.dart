import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:routine/models/models.dart';
import 'package:routine/services/todo_service.dart';
import 'package:uuid/uuid.dart';

abstract class BaseTodoListProvider {
  // todo list의 CRUD
  // TODO: date를 argument로 추가하기
  void loadTodoList();
  void createTodo();
  void toggleTodo({Todo todo});
  void deleteTodo(Todo todo);
}

class TodoListProvider with ChangeNotifier {
  /// Todo 목록
  TodoList _todoList = TodoList(id: 'id1', todos: []);
  TodoService _todoService = TodoService();

  /// Todo 로딩 상태
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  TodoList get todoList => _todoList;
  int count = 3;
  void loadTodoList() async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await _todoService.getTodoList();
      if (result != null) {
        _todoList = result;
      }
    } catch (e) {
      print(e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }

  /// createTodo는 해당 날짜에 할 일(Todo)을 추가하는 method입니다.
  /// "할일"
  void createTodo(String title) async {
    _todoList.todos
        .add(new Todo(id: '${Uuid().v1()}', title: title, isCompleted: false));
    await _todoService.updateTodoList(_todoList);
    notifyListeners();
  }

  /// 특정 todo의 상태를 변경시켜준다
  /// isCompleted 상태를 false -> true or true -> false
  /// 할일의 완료상태를 변경하는 method
  ///
  /// _todoList
  ///
  /// TodoListProvider <-> TodoListService(저장소)
  ///
  /// 1. 변경할 Todo의 모델을 받아옴
  /// 2. 상태 변경을 가함
  /// 3. 변경한 Todo의 모델을 todoList에 업데이트함
  /// 4. 상태변경됨을 알려줌
  ///
  /// Todo todo
  void toggleTodo(Todo todo) async {
    // 2. 상태 변경을 가함 (어떤 상태를 무슨 상태로 바꿔줘야 할까?)
    todo.isCompleted = !todo.isCompleted;
    // 3. 변경한 Todo의 모델을 todoList에 업데이트함
    List<Todo> newTodos =
        _todoList.todos.map((e) => e.id == todo.id ? todo : e).toList();

    _todoList.todos = newTodos;

    await _todoService.updateTodoList(_todoList);
    notifyListeners();
  }

  void deleteTodo(Todo todo) async {
    // 입력받은 todoId를 todos에서 찾아서 filter함
    _todoList.todos.remove(todo);

    await _todoService.updateTodoList(_todoList);
    notifyListeners();
  }
}
