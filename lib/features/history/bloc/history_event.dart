part of 'history_bloc.dart';

@immutable
abstract class HistoryEvent {}

class GetHistoryTasksEvent extends HistoryEvent { }
class ExportToCsvEvent extends HistoryEvent { }