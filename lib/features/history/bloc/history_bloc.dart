import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:time_tracker/database/app_database.dart';

import '../resource/history_repository.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final _repository = HistoryRepository();
  HistoryBloc() : super(HistoryInitial()){
    on<GetHistoryTasksEvent>(_repository.getHistoryTasks);
    on<ExportToCsvEvent>(_repository.exportToCsv);
  }
}