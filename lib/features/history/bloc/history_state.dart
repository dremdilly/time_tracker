part of 'history_bloc.dart';

@immutable
abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class GetHistoryTasksState extends HistoryState {
  final List<Tasks> completedTasks;
  GetHistoryTasksState(this.completedTasks);
}