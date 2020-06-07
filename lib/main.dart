import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routine/providers/todo_list_provider.dart';
import 'package:routine/screens/screens.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodoListProvider()..loadTodoList(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            textTheme: TextTheme(
              headline6: TextStyle(color: Colors.black87),
            ),
          ),
          primaryColor: Color.fromRGBO(251, 75, 75, 1),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Color.fromRGBO(251, 75, 75, 1),
          ),
          // primarySwatch: Colors.red,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
