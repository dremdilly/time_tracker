import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker/database/app_database.dart';
import 'package:time_tracker/features/home/resource/home_repository.dart';
import 'package:meta/meta.dart';
import 'package:time_tracker/models/TaskModel.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final _repository = HomeRepository();
  HomeBloc() : super(HomeInitial()){
    on<GetSectionsEvent>(_repository.getSections);
    on<AddTaskEvent>(_repository.addTask);
    on<GetTasksEvent>(_repository.getTasksBySection);
    on<ReorderTasksEvent>(_repository.reorderTasks);
    on<GetTaskTimerEvent>(_repository.getTaskTimer);
    on<StartTaskTimerEvent>(_repository.startTaskTimer);
    on<GetTaskStatusTimerEvent>(_repository.getTaskStatusTimer);
    on<GetTaskCompletedDateEvent>(_repository.getTaskCompletedDate);
  }
}