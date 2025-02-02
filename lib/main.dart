import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/Layout/HomeLayout.dart';
import 'shared/bloc observer.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}
