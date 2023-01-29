import 'package:drift/drift.dart';
import 'package:time_tracker/database/tables/sections_table.dart';
import 'package:time_tracker/database/tables/tasks_table.dart';

abstract class SectionTaskCount extends View {
  TasksTable get tasks;
  SectionsTable get sections;

  Expression<int> get itemCount => tasks.id.count();
  
  @override
  Query as() =>
      select([sections.title, itemCount])
        .from(sections)
        .join([innerJoin(tasks, tasks.section.equalsExp(sections.id))]);
}