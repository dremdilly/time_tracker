part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class LoadingSectionsState extends HomeState {}

class GetSectionsState extends HomeState {
  final List<Sections> sections;
  GetSectionsState(this.sections);
}

class ReorderTasksState extends HomeState {
  final double scrollPosition;
  final int draggedBySection;
  ReorderTasksState(this.scrollPosition, this.draggedBySection);
}

class AddTaskState extends HomeState{}

class GetTasksState extends HomeState {
  final List<Tasks> tasks;
  GetTasksState(this.tasks);
}

class GetTaskTimerState extends HomeState {
  final int seconds;
  GetTaskTimerState(this.seconds);
}

class GetTaskStatusTimerState extends HomeState {
  final bool timerStatus;
  GetTaskStatusTimerState(this.timerStatus);
}

class GetTaskCompletedDateState extends HomeState {
  final DateTime? completedDate;
  GetTaskCompletedDateState(this.completedDate);
}