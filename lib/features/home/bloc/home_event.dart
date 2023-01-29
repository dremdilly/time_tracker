part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class GetSectionsEvent extends HomeEvent {}

class ReorderTasksEvent extends HomeEvent {
  final Tasks task;
  final int nextPositionTask;
  final double scrollPosition;
  final int section;
  final int draggedBySection;
  ReorderTasksEvent(this.task, this.nextPositionTask, this.scrollPosition, this.section, this.draggedBySection);
}

class AddTaskEvent extends HomeEvent {
  final TaskModel taskModel;
  final Sections section;
  AddTaskEvent(this.taskModel, this.section);
}

class GetTasksEvent extends HomeEvent {
  final int section;
  GetTasksEvent(this.section);
}

class GetTaskTimerEvent extends HomeEvent {
  final int task;
  GetTaskTimerEvent(this.task);
}

class StartTaskTimerEvent extends HomeEvent {
  final bool timerStatus;
  final int value;
  final int task;
  StartTaskTimerEvent(this.timerStatus, this.value, this.task);
}

class GetTaskStatusTimerEvent extends HomeEvent {
  final int task;
  GetTaskStatusTimerEvent(this.task);
}

class GetTaskCompletedDateEvent extends HomeEvent {
  final int task;
  GetTaskCompletedDateEvent(this.task);
}