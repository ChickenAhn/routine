// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoList _$TodoListFromJson(Map<String, dynamic> json) {
  return TodoList(
    id: json['id'] as String,
    date: json['date'] as String,
    todos: (json['todos'] as List)
        ?.map(
            (e) => e == null ? null : Todo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$TodoListToJson(TodoList instance) => <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'todos': instance.todos?.map((e) => e?.toJson())?.toList(),
    };
