import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_tracker/constants/colors.dart';
import 'package:time_tracker/constants/text_style_values.dart';
import 'package:time_tracker/database/app_database.dart';
import 'package:time_tracker/features/home/bloc/home_bloc.dart';

class TaskItem extends StatefulWidget {
  final HomeBloc homeBloc;
  final Tasks task;

  const TaskItem({Key? key, required this.homeBloc, required this.task})
      : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> with SingleTickerProviderStateMixin{
  late HomeBloc homeBloc;
  bool isChecked = false;
  Timer? countdownTimer;
  Duration taskDuration = const Duration(seconds: 0);
  bool isTimerStarted = false;
  double _height = 75.h;
  double _width = 320.w;

  @override
  void initState() {
    homeBloc = HomeBloc();
    homeBloc.add(GetTaskStatusTimerEvent(widget.task.id));
    homeBloc.add(GetTaskTimerEvent(widget.task.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        bloc: homeBloc,
        listener: (context, state) {
          if (state is GetTaskStatusTimerState) {
            isTimerStarted = state.timerStatus;
            if (isTimerStarted) {
              startTimer();
            } else {
              countdownTimer?.cancel();
            }
          }
          if (state is GetTaskTimerState) {
            taskDuration = Duration(seconds: state.seconds);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.only(left: 14.w, right: 14.w),
            child: buildTaskBox(),
          );
        });
  }

  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(isTimerStarted) {
        setCountDown();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  void setCountDown() {
    const addSecondsBy = 1;
    setState(() {
      final seconds = taskDuration.inSeconds + addSecondsBy;
      taskDuration = Duration(seconds: seconds);
    });
  }

  Widget buildTaskBox() {
    return AnimatedContainer(
      constraints: BoxConstraints(maxWidth: _width, maxHeight: _height),
      duration: const Duration(milliseconds: 200),
      child: Material(
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
                            showTaskDueDate(),
                            showTimerCounter(),
                            showTimerPlayerButton()
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )),
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
          shape: CircleBorder(),
          onChanged: (bool? value) {
            setState(() {
              DateTime now = DateTime.now();
              sectionsDao.setTaskCompletedDate(now, widget.task.id);
              sectionsDao.setTaskStatus(value!, widget.task.id);
              isChecked = value;
              _height = 0;
              _width = 0;
            });
          },
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

  Widget showTaskDueDate() {
    return Expanded(
      flex: 8,
      child: Padding(
        padding: EdgeInsets.only(left: 0.w),
        child: Text(' ',
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
      flex: 2,
      child: Text("$minutes:$seconds"),
    );
  }

  Widget showTimerPlayerButton() {
    return Expanded(
      flex: 2,
      child: IconButton(
        padding: EdgeInsets.only(right: 5.w),
        enableFeedback: true,
        icon: Icon(
          (!isTimerStarted) ? Icons.play_circle : Icons.stop_circle,
          size: 21.0,
          color: (!isTimerStarted) ? Colors.green : Colors.red,
        ),
        color: AppColors.black,
        onPressed: (!isTimerStarted)
            ? () {
                isTimerStarted = true;
                homeBloc
                    .add(StartTaskTimerEvent(isTimerStarted, taskDuration.inSeconds, widget.task.id));
                startTimer();
              }
            : () {
                isTimerStarted = false;
                homeBloc
                    .add(StartTaskTimerEvent(isTimerStarted, taskDuration.inSeconds, widget.task.id));
                sectionsDao.setTaskDuration(taskDuration.inSeconds, widget.task.id);
                countdownTimer?.cancel();
                setState(() {});
              },
      ),
    );
  }
}
