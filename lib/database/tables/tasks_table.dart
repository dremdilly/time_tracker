import 'package:drift/drift.dart';
import 'package:time_tracker/database/tables/sections_table.dart';

@DataClassName('Tasks')
class TasksTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 32)();
  IntColumn get position => integer()();
  IntColumn get duration => integer().withDefault(const Constant(0))();
  BoolColumn get status => boolean().withDefault(const Constant(false))();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
  IntColumn get section => integer().references(SectionsTable, #id)();
  DateTimeColumn get completedDate => dateTime().nullable()();
}