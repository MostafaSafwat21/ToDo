import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class ArchivedTasks extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppStates>(
      listener: (context , state){},
      builder: (context , state){
        var Tasks = AppCubit.get(context).archivedTasks;

        return ConditionalBuilder(
          condition: Tasks.length > 0,
          builder: (BuildContext context) => ListView.separated(
            itemBuilder: (context, index) {
              return buildTaskItem(Tasks[index] , context);
            },
            separatorBuilder: (context, index) => Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
            itemCount: Tasks.length,
          ),
          fallback: (BuildContext context) => Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.archive_outlined,
                    color: Colors.black87,
                    size: 100,
                  ),
                  Text(
                    'No Archived Tasks',
                    style: (
                        TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey,
                        )
                    ),
                  ),
                ],
              ),
            ),
          ),

        );
        },
    );
  }
}
