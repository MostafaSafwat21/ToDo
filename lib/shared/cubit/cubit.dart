import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/shared/cubit/states.dart';
import '../../moduels/Archived Tasks/Archived.dart';
import '../../moduels/Done Tasks/Done.dart';
import '../../moduels/New Tasks/New.dart';
import '../components/constants.dart';

class AppCubit extends Cubit<AppStates>{

  AppCubit(): super(AppInitialStates());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentindex = 0;

  List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];

  List<String> titels = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void ChangeIndex(int index){
    currentindex = index;
    emit(AppChangeBottomNavBarState());
  }

  late Database database;
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archivedTasks=[];

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version)
      {
        print('Database Created');
        database.execute('CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('Table Created');
        }).catchError((error)
        {
          print('error on creating table ${error.toString()}');
        });
      },
      onOpen: (database)
      {
        getDataFromDatabase(database);
        print('Database Opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  Future insertDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
     await database.transaction((txn) {
      return txn.rawInsert(
        'INSERT INTO Tasks(title, date, time, status) VALUES("$title","$date","$time","new")'
    ).then((value)
    {
      print('$value inserted successfully');
      emit(AppInsertDatabaseState());
      getDataFromDatabase(database);
    }
    ).catchError((error)
      {
        print('Error when inserting New record ${error.toString()}');
      }
    );
    }
  );
  }

  void getDataFromDatabase(database)  {

    newTasks= [];
    doneTasks= [];
    archivedTasks= [];

    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM Tasks').then((value)
    {
        Tasks = value;
        value.forEach((element)
        {
        if(element['status'] == 'new'){
          newTasks.add(element);
        }
        else if(element['status'] == 'done'){
          doneTasks.add(element);
        }
        else archivedTasks.add(element);
        print(element['status']);
      });
      emit(AppGetDatabaseState());
    });
  }

  bool isBottomSheetShow = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShow = isShow ;
    fabIcon = icon ;
    emit(AppChangeBottomSheetState());
  }

  void updateDate({
    required String status ,
    required int id,
}) async {
    database.rawUpdate(
      'UPDATE Tasks SET status =? Where id =?',
      ['$status',id],
    ).then((value){
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteDate({
    required int id,
}) async {
    database.rawDelete(
      'DELETE FROM Tasks WHERE id =? ',[id])
        .then((value){
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

}

