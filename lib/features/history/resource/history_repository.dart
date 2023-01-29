import 'package:csv/csv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker/database/app_database.dart';
import 'package:time_tracker/features/history/bloc/history_bloc.dart';
import 'package:time_tracker/utils/csv_utils.dart';

class HistoryRepository {
  Future<List<Tasks>?> getHistoryTasks(GetHistoryTasksEvent event, Emitter<HistoryState> emit) async {
    List<Tasks> completedTasks = [];
    completedTasks.addAll(await sectionsDao.getHistoryTasks());
    emit(GetHistoryTasksState(completedTasks));
  }

  Future<void> exportToCsv(ExportToCsvEvent event, Emitter<HistoryState> emit) async {
    var csvData = CsvUtils().mapListToCsv(await sectionsDao.getCompletedTasksTable(), converter: ListToCsvConverter());
    CsvUtils().generateCsv(csvData!);
  }
}