import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:routine/models/models.dart';

class TodoListProvider with ChangeNotifier {
  /// TDodo 목록
  List<Todo> _todos;

  /// Todo 로딩 상태
  bool _isLoading = false;

  int get count => 1;
  bool get isLoading => _isLoading;
  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);

  Future<List<Todo>> loadTodoList() {
    _isLoading = true;
    notifyListeners();

    return Future.value([
      Todo(id: 'todo1', title: 'todo', isCompleted: false),
    ]);
  }
}
