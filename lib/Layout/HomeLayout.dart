import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/shared/components/components.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {

  var ScaffoldKey = GlobalKey<ScaffoldState>();
  var FormKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, State) {
          if (State is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: ScaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titels[cubit.currentindex],
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            .),
            body: Container(
              color: Colors.limeAccent.shade100,
              child: ConditionalBuilder(
                condition: state is! AppGetDatabaseLoadingState, //Tasks.length > 0,
                builder: (context) => cubit.screens[cubit.currentindex],
                fallback: (context) => const Center(
                    child: CircularProgressIndicator()
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShow) {
                  if (FormKey.currentState!.validate()) {
                    cubit.insertDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    );
                  }
                }
                else {
                  ScaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          padding: EdgeInsets.all(20.0),
                          color: Colors.white,
                          child: Form(
                            key: FormKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFromField(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Title must not be empty';
                                    }
                                  },
                                  onSubmit: (String? value){
                                    if(FormKey.currentState!.validate()){}
                                  },
                                  label: 'Task Title',
                                  prefix: Icons.title,
                                ),

                                SizedBox(
                                  height: 20,
                                ),

                                defaultFromField(
                                  controller: timeController,
                                  type: TextInputType.datetime,
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                      print(value.format(context));
                                    });
                                  },
                                  onSubmit: (String value){
                                    if(FormKey.currentState!.validate());
                                  },
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Time must not be empty';
                                    }
                                  },
                                  label: 'Task Time',
                                  prefix: Icons.watch_later_outlined,
                                ),

                                SizedBox(
                                  height: 20,
                                ),

                                defaultFromField(
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2030-05-21'),
                                    ).then((value) {
                                      dateController.text =
                                          DateFormat.MMMd().format(value!);
                                    });
                                  },
                                  onSubmit: (String value){
                                    if(FormKey.currentState!.validate());
                                  },
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Data must not be empty';
                                    }
                                  },
                                  label: 'Task Data',
                                  prefix: Icons.calendar_today,
                                ),
                              ],
                            ),
                          ),
                        ),
                    elevation: 20,
                  ).closed.then((value)
                  {
                    cubit.changeBottomSheetState(
                      isShow: false,
                      icon: Icons.edit
                    );
                  });
                  cubit.changeBottomSheetState(
                      isShow: true,
                      icon: Icons.add,
                  );
                }
              },
              backgroundColor: Colors.lightGreenAccent,
              child: Icon(
                cubit.fabIcon,
                size: 35,
                color: Colors.black,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentindex,
              onTap: (index) {
                cubit.ChangeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon
                    (
                      Icons.menu),
                  label: 'New Tasks',
                ),
                BottomNavigationBarItem(
                    icon: Icon
                      (
                        Icons.check_circle),
                    label: 'Done'
                ),
                BottomNavigationBarItem(
                    icon: Icon
                      (
                        Icons.archive),
                    label: 'Archived'
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
