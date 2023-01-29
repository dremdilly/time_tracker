import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:time_tracker/database/dao/sections_dao.dart';
import 'package:time_tracker/database/tables/sections_table.dart';
import 'package:time_tracker/database/tables/tasks_table.dart';
import 'package:time_tracker/database/views/SectionTaskCount.dart';

part 'app_database.g.dart';

late AppDatabase appDatabase;
late SectionsDao sectionsDao;

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'time_tracker_app.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [SectionsTable, TasksTable], views: [SectionTaskCount])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  void initDao(AppDatabase db) {
    sectionsDao = SectionsDao(db);
  }

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
        onCreate: (Migrator m) async => await m.createAll(),
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON;');
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from <= 1) {
            await m.createTable(sectionsTable);
            await m.createTable(tasksTable);
          }
        }
    );
  }
}