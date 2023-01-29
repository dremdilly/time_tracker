import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker/database/app_database.dart';
import 'package:time_tracker/features/home/bloc/home_bloc.dart';

class HomeRepository {
  Future<void> addTask(AddTaskEvent event, Emitter<HomeState> emit) async {
    sectionsDao.insertTask(event.taskModel, event.section);
    emit(AddTaskState());
  }

  Future<void> getSections(GetSectionsEvent event, Emitter<HomeState> emit) async {
    List<Sections> sections = await sectionsDao.getSections();
    emit(GetSectionsState(sections));
  }

  Future<void> getTasksBySection(GetTasksEvent event, Emitter<HomeState> emit) async {
    List<Tasks> tasks = await sectionsDao.getTasksBySection(event.section);
    emit(GetTasksState(tasks));
  }

  Future<void> reorderTasks(ReorderTasksEvent event, Emitter<HomeState> emit) async {
    if(event.task.section == event.section) {
      sectionsDao.reorderTask(
          event.task, event.nextPositionTask);
    } else {
      sectionsDao.reorderTaskBetweenSections(
          event.task, event.nextPositionTask, event.section);
    }
    emit(ReorderTasksState(event.scrollPosition, event.draggedBySection));
  }

  Future<void> getTaskTimer(GetTaskTimerEvent event, Emitter<HomeState> emit) async {
    int seconds = await sectionsDao.getTaskDurationTimer(event.task);
    emit(GetTaskTimerState(seconds));
  }

  Future<void> startTaskTimer(StartTaskTimerEvent event, Emitter<HomeState> emit) async {
    await sectionsDao.setTaskDurationStatusTimer(event.timerStatus, event.task);
    await sectionsDao.setTaskDurationTimer(event.value, event.task);
    // emit(GetTaskStatusTimerState(event.timerStatus));
    // if(event.timerStatus) {
    // }
  }

  Future<void> getTaskStatusTimer(GetTaskStatusTimerEvent event, Emitter<HomeState> emit) async {
    bool timerStatus = await sectionsDao.getTaskDurationStatusTimer(event.task);
    emit(GetTaskStatusTimerState(timerStatus));
  }

  Future<DateTime?> getTaskCompletedDate(GetTaskCompletedDateEvent event, Emitter<HomeState> emit) async {
    DateTime? completedDate = await sectionsDao.getTaskCompletedDate(event.task);
    emit(GetTaskCompletedDateState(completedDate));
  }
}