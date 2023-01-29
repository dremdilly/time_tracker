import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_tracker/database/app_database.dart';
import 'package:time_tracker/database/tables/sections_table.dart';
import 'package:time_tracker/database/tables/tasks_table.dart';
import 'package:time_tracker/models/SectionModel.dart';
import 'package:time_tracker/models/TaskModel.dart';


part 'sections_dao.g.dart';

@DriftAccessor(tables: [SectionsTable, TasksTable])
class SectionsDao extends DatabaseAccessor<AppDatabase>
    with _$SectionsDaoMixin {
  SectionsDao(AppDatabase appDatabase) : super(appDatabase);

  Future<void> insertSection(SectionModel section) async {
    into(sectionsTable).insert(
        SectionsTableCompanion.insert(title: section.title));
  }

  Future<void> insertTask(TaskModel task, Sections section) async {
    try {
      int? lastOrder = await customSelect(
        'SELECT MAX(position) AS c FROM tasks_table WHERE section = ?',
        variables: [Variable.withInt(section.id)], readsFrom: {tasksTable},)
          .map((row) => row.read<int?>('c')).getSingle();
      into(tasksTable).insert(
          TasksTableCompanion.insert(
              title: task.title,
              section: section.id,
              position: lastOrder != null ? lastOrder + 1 : 1));
    } catch (e) {
      debugPrint(e.toString());
      await into(tasksTable).insert(
          TasksTableCompanion.insert(
              title: task.title, section: section.id, position: 1));
    }
  }

  Future<List<Sections>> getSections() async {
    List<Sections> sections = [];
    sections.addAll(await (select(sectionsTable)).get());
    return sections;
  }

  Future<void> deleteTask(Tasks deletedTask) async {
    int? lastOrder = (await (select(tasksTable)
      ..where((tbl) => tbl.section.equals(deletedTask.id))
      ..orderBy(([(t) => OrderingTerm.desc(t.position)]))).get()).last.position;
    delete(tasksTable).where((tbl) => tbl.id.equals(deletedTask.id));
    await db.customStatement(
        "UPDATE 'tasksTable' SET position = position-1 WHERE position between ? and ?",
        [deletedTask.position + 1, lastOrder]);
  }

  Future<void> reorderTask(Tasks reorderedTask, int nextTaskPosition) async {
    if (reorderedTask.position > nextTaskPosition) {
      await db.customStatement(
          "UPDATE tasks_table SET position = position + 1 WHERE section = ? and position between ? and ?",
          [reorderedTask.section, nextTaskPosition, reorderedTask.position]);
      await update(tasksTable).replace(
          reorderedTask.copyWith(position: nextTaskPosition));
    } else if (reorderedTask.position < nextTaskPosition) {
      await db.customStatement(
          "UPDATE tasks_table SET position = position - 1 WHERE section = ? and position between ? and ?",
          [
            reorderedTask.section,
            reorderedTask.position,
            nextTaskPosition - 1
          ]);
      await update(tasksTable).replace(
          reorderedTask.copyWith(position: nextTaskPosition - 1));
    }
  }

  Future<void> reorderTaskBetweenSections(Tasks reorderedTask,
      int nextTaskPosition, int section) async {
    int? lastOrderOfDraggedBySection = (await (select(tasksTable)
      ..where((tbl) => tbl.section.equals(reorderedTask.section))
      ..orderBy(([(t) => OrderingTerm(expression: t.position)]))).get()).last
        .position;
    int? lastOrderOfTargetSection = await customSelect(
      'SELECT MAX(position) AS c FROM tasks_table WHERE section = ?',
      variables: [Variable.withInt(section)], readsFrom: {tasksTable},)
        .map((row) => row.read<int?>('c')).getSingle();

    await db.customStatement(
        "UPDATE tasks_table SET position = position - 1 WHERE section = ? and position between ? and ?",
        [
          reorderedTask.section,
          reorderedTask.position + 1,
          lastOrderOfDraggedBySection
        ]);
    await db.customStatement(
        "UPDATE tasks_table SET position = position + 1 WHERE section = ? and position between ? and ?",
        [section, nextTaskPosition, lastOrderOfTargetSection]);
    await update(tasksTable).replace(
        reorderedTask.copyWith(position: nextTaskPosition, section: section));
  }

  Future<List<Tasks>> getTasksBySection(int section) async {
    List<Tasks> tasks = [];
    tasks.addAll(await (select(tasksTable)
      ..where((tbl) => tbl.section.equals(section))..where((tbl) =>
          tbl.isDone.equals(false))
      ..orderBy(([(t) => OrderingTerm(expression: t.position)]))).get());
    return tasks;
  }

  Future<void> setTaskDurationStatusTimer(bool value, int task) async {
    await db.customStatement(
        "UPDATE tasks_table SET status = ? WHERE id = ?",
        [value, task]);
  }

  Future<bool> getTaskDurationStatusTimer(int task) async {
    return await customSelect(
      'SELECT status AS c FROM tasks_table WHERE id = ?',
      variables: [Variable.withInt(task)], readsFrom: {tasksTable},)
        .map((row) => row.read<bool>('c')).getSingle();
  }

  Future<void> setTaskDuration(int value, int task) async {
    await db.customStatement(
        "UPDATE tasks_table SET duration = ? WHERE id = ?",
        [value, task]);
  }

  Future<void> setTaskDurationTimer(int value, int task) async {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (await getTaskDurationStatusTimer(task)) {
        await db.customStatement(
            "UPDATE tasks_table SET duration = ? WHERE id = ?",
            [++value, task]);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> setTaskStatus(bool isDone, int task) async {
    await db.customStatement(
        "UPDATE tasks_table SET is_done = ? WHERE id = ?",
        [isDone, task]);
  }

  Future<int> getTaskDurationTimer(int task) async {
    return await customSelect(
      'SELECT duration AS c FROM tasks_table WHERE id = ?',
      variables: [Variable.withInt(task)], readsFrom: {tasksTable},)
        .map((row) => row.read<int>('c')).getSingle();
  }

  Future<List<Tasks>> getHistoryTasks() async {
    List<Tasks> tasks = [];
    tasks.addAll(await (select(tasksTable)
      ..where((tbl) => tbl.isDone.equals(true))
      ..orderBy(([(t) => OrderingTerm.desc(t.completedDate)]))).get());
    return tasks;
  }

  Future<void> setTaskCompletedDate(DateTime? completedDate, int task) async {
    int time = (completedDate!.millisecondsSinceEpoch / 1000).ceil();
    await db.customStatement(
        "UPDATE tasks_table SET completed_date = ? WHERE id = ?",
        [time, task]);
  }

  Future<DateTime?> getTaskCompletedDate(int task) async {
    return await customSelect(
      'SELECT completed_date AS c FROM tasks_table WHERE id = ? and is_done = ?',
      variables: [Variable.withInt(task), Variable.withBool(true)], readsFrom: {tasksTable},)
        .map((row) => row.read<DateTime?>('c')).getSingle();
  }

  Future<List<Map<String, dynamic>>?> getCompletedTasksTable() async {
    var result = await db.customSelect(
        'SELECT title, duration, completed_date FROM tasks_table WHERE is_done = ?',
        variables: [Variable.withBool(true)], readsFrom: {tasksTable},).get();
    List<Map<String, dynamic>>? list = <Map<String, dynamic>>[];
    for(var item in result) {
      list.add(item.data);
    }
    return list;
  }
}
