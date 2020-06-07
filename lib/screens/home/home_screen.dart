import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routine/models/models.dart';
import 'package:routine/providers/todo_list_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildHeader(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // _buildHeader(),
              _buildTodoList(),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FloatingActionButton(
          onPressed: () {
            _showCreateTodoBottomSheet(context);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            '오늘',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 16),
          Text(
            '5월 28일 목요일',
            style: TextStyle(fontSize: 14, color: Colors.black45),
          ),
        ],
      ),
    );
  }

  /// assets/empty_todo.png
  Widget _buildPlaceholder() {
    return Column(
      children: <Widget>[
        SizedBox(height: 120),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Image.asset('assets/empty_todo.png'),
        ),
        Text("무엇을 해야하나요?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        Text(
          "할일을 작성하면 목록에 표시됩니다\n아래 + 버튼을 눌러 할일을 만들어 보세요",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black45,
          ),
        ),
      ],
    );
  }

  void _showCreateTodoBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
        ),
        builder: (_) {
          return Wrap(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: CreateTodoForm(),
                    )),
              ]);
        });
  }

  Widget _buildTodoList() {
    return Consumer<TodoListProvider>(
      builder: (_, todoListProvider, child) {
        if (!todoListProvider.isLoading) {
          final List<Todo> todos = todoListProvider.todoList?.todos;
          if (todos != null) {
            return ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              itemCount: todos.length,
              itemBuilder: (context, index) {
                Todo todo = todos[index];
                return TodoItem(
                  todo: todo,
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 12),
            );
          }
          return Center(child: _buildPlaceholder());
        }
        return Container();
      },
    );
  }
}

class CreateTodoForm extends StatefulWidget {
  const CreateTodoForm({Key key}) : super(key: key);

  @override
  _CreateTodoFormState createState() => _CreateTodoFormState();
}

class _CreateTodoFormState extends State<CreateTodoForm> {
  TextEditingController textInputController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TodoListProvider todoListProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textInputController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    todoListProvider = Provider.of<TodoListProvider>(context);
    return Form(
      key: _formKey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              autofocus: true,
              autocorrect: false,
              controller: textInputController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '할일을 작성해 보세요',
              ),
              maxLines: 3,
              // validator: (String value) {
              //   if (value.isEmpty) return "";

              //   return null;
              // },
            ),
          ),
          ClipOval(
            child: Material(
              color: Theme.of(context).primaryColor,
              child: InkWell(
                onTap: () {
                  if (textInputController.text.isNotEmpty) {
                    // textInputController.text -> createTodo
                    todoListProvider.createTodo(textInputController.text);
                    Navigator.of(context).pop();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TodoItem extends StatefulWidget {
  TodoItem({@required this.todo});
  final Todo todo;
  @override
  _TodoItemState createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        trailing: widget.todo.isCompleted
            ? IconButton(
                onPressed: () {
                  Provider.of<TodoListProvider>(context, listen: false)
                      .deleteTodo(widget.todo);
                },
                // highlightColor: Colors.transparent,
                // splashColor: Colors.transparent,
                icon: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              )
            : null,
        leading: Checkbox(
          value: widget.todo.isCompleted,
          onChanged: (bool value) {
            Provider.of<TodoListProvider>(context, listen: false)
                .toggleTodo(widget.todo);
          },
        ),
        title: Text(
          widget.todo.title,
          style: widget.todo.isCompleted
              ? TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.lineThrough,
                  color: Colors.black.withOpacity(0.3),
                )
              : TextStyle(fontSize: 16),
        ),
      ),
      // Text(widget.todo.title),
    );
  }
}
