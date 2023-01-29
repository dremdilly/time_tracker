import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker/constants/colors.dart';
import 'package:time_tracker/constants/text_style_values.dart';
import 'package:time_tracker/database/app_database.dart';
import 'package:time_tracker/features/history/bloc/history_bloc.dart';
import 'package:time_tracker/features/home/bloc/home_bloc.dart';

class HistoryTaskItem extends StatefulWidget {
  final Tasks task;

  const HistoryTaskItem({Key? key, required this.task})
      : super(key: key);

  @override
  State<HistoryTaskItem> createState() => _HistoryTaskItemState();
}

class _HistoryTaskItemState extends State<HistoryTaskItem> {
  late HomeBloc homeBloc;
  late HistoryBloc historyBloc;
  bool isChecked = true;
  Timer? countdownTimer;
  Duration taskDuration = const Duration(seconds: 0);
  bool isTimerStarted = false;
  DateTime completedDate = DateTime.now();

  @override
  void initState() {
    historyBloc = HistoryBloc();
    homeBloc = HomeBloc();
    homeBloc.add(GetTaskTimerEvent(widget.task.id));
    homeBloc.add(GetTaskCompletedDateEvent(widget.task.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        bloc: homeBloc,
        listener: (context, state) {
          if (state is GetTaskTimerState) {
            taskDuration = Duration(seconds: state.seconds);
          }
          if (state is GetTaskCompletedDateState) {
            if(state.completedDate != null) {
              setState(() {
                completedDate = state.completedDate!;
              });
            }
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.only(left: 14.w, right: 14.w),
            child: buildTaskBox(),
          );
        });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  Widget buildTaskBox() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 320.w, maxHeight: 75.h),
          child: Container(
              decoration: getTaskBoxDecoration(),
              child: Row(
                children: [
                  showTaskStatusCheckBox(),
                  Expanded(
                    child: Column(
                      children: [
                        showTaskTitle(),
                        SizedBox(height: 5.h),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              showTaskCompletedDate(),
                              showTimerCounter()
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  BoxDecoration getTaskBoxDecoration() {
    return BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        border: Border.all(color: AppColors.lightGray, width: 1.w),
        boxShadow: [
          BoxShadow(
              color: AppColors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1))
        ]);
  }

  Widget showTaskStatusCheckBox() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 1.h),
        child: Checkbox(
          checkColor: AppColors.white,
          fillColor: const MaterialStatePropertyAll(AppColors.gray),
          value: isChecked,
          visualDensity: VisualDensity.comfortable,
          shape: const CircleBorder(),
          onChanged: (bool? value) {},
        ),
      ),
    );
  }

  Widget showTaskTitle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Text(widget.task.title,
            style: AppTextStyles.regular_black.copyWith(fontSize: 21.sp)),
      ),
    );
  }

  Widget showTaskCompletedDate() {
    var formatter = DateFormat('dd MMM yyyy');
    String formattedDate = formatter.format(completedDate);
    return Expanded(
      flex: 8,
      child: Padding(
        padding: EdgeInsets.only(left: 0.w),
        child: Text('Completed $formattedDate',
            style: AppTextStyles.regular_black
                .copyWith(color: AppColors.gray, fontSize: 18.sp)),
      ),
    );
  }

  Widget showTimerCounter() {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(taskDuration.inMinutes.remainder(60));
    final seconds = strDigits(taskDuration.inSeconds.remainder(60));
    return Expanded(
      flex: 4,
      child: Text("$minutes:$seconds"),
    );
  }
}
