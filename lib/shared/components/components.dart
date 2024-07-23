import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import '../cubit/cubit.dart';
import 'constants.dart';

Widget defaultFromField ({
  required TextEditingController controller,
  required TextInputType type,
  String? Function(String?)? validate,
  Function? onTap,
  required String label,
  required IconData prefix,
  IconData? suffix,
  bool isPassword = true,
  Function? onSubmit,
  Function? suffixPressed,
  }) => TextFormField(

  controller: controller ,
  keyboardType: type,
  validator: validate,
  onTap: (){
    onTap!();
  },
  onFieldSubmitted:(s){
    onSubmit!();
  } ,
  decoration: InputDecoration(
    labelText: label,
    border: OutlineInputBorder(),
    prefixIcon: Icon(
      prefix,
    ),
    suffixIcon: suffix!= null ? IconButton(
      onPressed: () {
        suffixPressed!();
      },
      icon: Icon(
        suffix,
      ),
    ) : null ,
  ),
);

Widget buildTaskItem(Map model , context) => Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (direction){
    AppCubit.get(context).deleteDate(id: model['id']);
  },
  child:   Padding(
      padding: const EdgeInsets.all(12.0),
        child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
              '${model['time']}',
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model['title']}',
                  textWidthBasis: TextWidthBasis.longestLine,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    overflow: TextOverflow.ellipsis
                  ),
                ),
                Text(
                  '${model['date']}',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: (){
              AppCubit.get(context).updateDate(
                status: 'done',
                id: model['id'],
              );
            },
            icon: Icon(
              Icons.check_box_rounded,
              color: Colors.green,
              size: 25,
            ),
          ),
          IconButton(
            onPressed: (){
              AppCubit.get(context).updateDate(
                status: 'archived',
                id: model['id'],
              );
            },
            icon: Icon(
              Icons.archive_rounded,
              color: Colors.black,
              size: 25,
            ),
          ),
        ],
      ),
    ),
);