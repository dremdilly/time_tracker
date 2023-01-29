import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_tracker/constants/colors.dart';
import 'package:time_tracker/constants/text_style_values.dart';
import 'package:time_tracker/database/app_database.dart';
import 'package:time_tracker/features/home/bloc/home_bloc.dart';
import 'package:time_tracker/features/home/ui/widget/task_item.dart';
import 'package:time_tracker/localization/extensions.dart';
import 'package:time_tracker/models/TaskModel.dart';
import 'package:time_tracker/translations_key/locale_keys.g.dart';

class SectionItem extends StatefulWidget {
  final PageController pageController;
  final Sections section;

  const SectionItem(
      {Key? key, required this.pageController, required this.section})
      : super(key: key);

  @override
  State<SectionItem> createState() => _SectionItemState();
}

class _SectionItemState extends State<SectionItem>
    with TickerProviderStateMixin {
  late HomeBloc homeBloc;

  PageController get pageController => widget.pageController;
  final ScrollController _scrollController = ScrollController();
  bool isEmptyTextField = true;
  final TextEditingController _controller = TextEditingController();
  final _key = const PageStorageKey('tasks');
  late List<Widget> children;
  late AnimationController _animationController;
  bool isDragged = false;
  bool draggedBetweenSections = false;

  @override
  void initState() {
    homeBloc = HomeBloc();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      value: 5 / 360,
    );
    homeBloc.add(GetTasksEvent(widget.section.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (event) {
        if (event.localPosition.dx > 350 && isDragged) {
          int? currentPage = pageController.page?.ceil();
          if (currentPage != null) {
            Future.delayed(const Duration(milliseconds: 1000), () {
              pageController.animateToPage(currentPage + 1,
                  duration: const Duration(milliseconds: 1000),

                  curve: Curves.fastLinearToSlowEaseIn);
              draggedBetweenSections = true;
            });
          }
        }
        if (event.localPosition.dx < 20 && isDragged) {
          int? currentPage = pageController.page?.ceil();
          if (currentPage != null && currentPage != 0) {
            Future.delayed(const Duration(milliseconds: 1000), () {
              pageController.animateToPage(currentPage - 1,
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.fastLinearToSlowEaseIn);

              draggedBetweenSections = true;
            });
          }
        }
      },
      child: BlocConsumer(
        bloc: homeBloc,
        listener: (context, state) {},
        builder: (context, state) {
          List<Widget> children = [];
          if (state is ReorderTasksState) {
            homeBloc.add(GetTasksEvent(widget.section.id));
            Future.delayed(const Duration(milliseconds: 50), () {
              _scrollController.animateTo(
                state.scrollPosition,
                curve: Curves.linear,
                duration: const Duration(milliseconds: 50),
              );
            });
          }
          if (state is AddTaskState) {
            homeBloc.add(GetTasksEvent(widget.section.id));
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              curve: Curves.linear,
              duration: const Duration(milliseconds: 200),
            );
          }
          if (state is GetTasksState) {
            for (var item in state.tasks) {
              children
                  .add(buildDragTargetTask(item.position));
              Widget _taskItem = TaskItem(
                homeBloc: homeBloc,
                task: item,
              );
              children.add(buildDraggableTask(_taskItem));
            }
            children
                .add(buildDragTargetTask(state.tasks.length+1));
          }
          return buildBody(children);
        },
      ),
    );
  }

  Widget buildBody(List<Widget> tasks) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      controller: _scrollController,
      child: Column(children: [
        SizedBox(height: 25.h),
        buildSectionHeader(),
        Column(
          key: _key,
          children: tasks,
        ),
        buildAddTaskButton(),
      ]),
    );
  }

  Widget buildDraggableTask(Widget taskItem) {
    return LongPressDraggable(
        data: taskItem,
        childWhenDragging: Container(),
        feedback: RotationTransition(
          turns: Tween(begin: 0.0, end: 5 / 360)
              .animate(_animationController),
          child: Opacity(
            opacity: 0.5,
            child: taskItem,
          ),
        ),
        onDragStarted: () {
          isDragged = true;
          _animationController.forward(from: 0);
        },
        onDragEnd: (draggableDetails) {
          isDragged = false;
          _animationController.animateBack(0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.bounceOut);
        },
        onDragCompleted: () {
          if(draggedBetweenSections) {
            Future.delayed(const Duration(milliseconds: 500), () {
              homeBloc.add(GetTasksEvent(widget.section.id));
            });
          }
        },
        child: taskItem);
  }

  Widget buildDragTargetTask(int nextTaskPosition) {
    late Tasks task;
    bool isDropped = false;
    return DragTarget(onWillAccept: (data) {
      if (data is TaskItem &&
          data.task.position != nextTaskPosition &&
          data.task.position != nextTaskPosition - 1 &&
          data.task.section == widget.section.id) {
        task = data.task;
        return true;
      } else if (data is TaskItem && data.task.section != widget.section.id) {
        draggedBetweenSections = true;
        task = data.task;
        return true;
      } else {
        return false;
      }
    }, onAccept: (data) {
        homeBloc.add(
            ReorderTasksEvent(task, nextTaskPosition, _scrollController.offset, widget.section.id, task.section));
        setState(() {
          isDropped = true;
        });
    }, builder: (context, accepted, rejected) {
      if (accepted.isEmpty && !isDropped) {
        return SizedBox(
          height: 20.h,
          width: 320.w,
        );
      } else {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: AnimatedContainer(
            padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
            height: 75.h,
            width: 320.w,
            color: AppColors.lightRed,
            curve: Curves.fastOutSlowIn,
            duration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  Widget buildSectionHeader() {
    return SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [buildSectionName(), buildSectionMenu()],
        ));
  }

  Widget buildSectionName() {
    return Padding(
        padding: EdgeInsets.only(left: 10.w),
        child: Text(widget.section.title,
            style: AppTextStyles.h3_white
                .copyWith(color: AppColors.black, fontSize: 25.sp)));
  }

  Widget buildSectionMenu() {
    return IconButton(
      padding: EdgeInsets.only(right: 5.w),
      enableFeedback: false,
      icon: const ImageIcon(
        AssetImage('assets/icons/ic_three_dots.png'),
        size: 30.0,
        color: AppColors.black,
      ),
      color: AppColors.black,
      onPressed: () {},
    );
  }

  Widget buildAddTaskButton() {
    return Padding(
      padding: EdgeInsets.only(left: 14.w, right: 14.w, bottom: 20.h),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
            style: ButtonStyle(
              minimumSize: MaterialStatePropertyAll(Size.fromHeight(75.h)),
              backgroundColor: const MaterialStatePropertyAll(AppColors.white),
              alignment: Alignment.centerLeft,
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: AppColors.lightGray),
                  borderRadius: BorderRadius.circular(10.r))),
            ),
            label: Text(LocaleKeys.addTask.tr(),
                style: AppTextStyles.regular_black),
            icon: const Icon(
              Icons.add,
              size: 30.0,
              color: AppColors.lightRed,
            ),
            onPressed: () {
              showAddSectionTextField();
            }),
      ),
    );
  }

  void showAddSectionTextField() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.r))),
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: TextField(
                controller: _controller,
                autofocus: true,
                style: AppTextStyles.regular_black
                    .copyWith(fontWeight: FontWeight.bold),
                decoration: getTaskInputDecoration(),
                onSubmitted: (value) => _addNewTask(value),
                onChanged: (value) {
                  value.isNotEmpty
                      ? setState(() => isEmptyTextField = false)
                      : setState(() => isEmptyTextField = true);
                },
              ),
            );
          });
        });
  }

  void _addNewTask(String value) {
    homeBloc.add((AddTaskEvent(TaskModel(title: value), widget.section)));
    Navigator.pop(context);
  }

  InputDecoration getTaskInputDecoration() {
    return InputDecoration(
        contentPadding: EdgeInsetsDirectional.only(start: 10.w, top: 20.h),
        hintText: LocaleKeys.taskName.tr(),
        hintStyle: AppTextStyles.regular_black
            .copyWith(fontWeight: FontWeight.bold, color: AppColors.lightGray),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(width: 0.0, color: Colors.white)),
        suffixIcon: IconButton(
          icon: ImageIcon(
            const AssetImage('assets/icons/ic_arrow_up_circle.png'),
            size: 30.r,
          ),
          color: !isEmptyTextField ? AppColors.lightRed : AppColors.gray,
          onPressed: !isEmptyTextField
              ? () {
                  _addNewTask(_controller.value.text);
                }
              : null,
        ));
  }
}
