import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)

/// Todo의 데이터 모델
class Todo {
  Todo({
    this.id,
    this.title,
    this.isCompleted,
  });

  /// unique id
  String id;

  /// 제목
  String title;

  /// 완료상태
  bool isCompleted;

  // bool toggleCompleted() {
  //   return this.isCompleted;
  // }

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);
}
