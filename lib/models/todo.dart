import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Todo {
  Todo({
    this.id,
    this.title,
    this.isCompleted,
  });

  String id;
  String title;
  bool isCompleted;

  bool toggleCompleted() {
    return this.isCompleted;
  }

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);
}
