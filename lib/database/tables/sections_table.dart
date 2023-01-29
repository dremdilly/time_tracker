import 'package:drift/drift.dart';

@DataClassName('Sections')
class SectionsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 32)();
}