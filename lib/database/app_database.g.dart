// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SectionsTableTable extends SectionsTable
    with TableInfo<$SectionsTableTable, Sections> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SectionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, title];
  @override
  String get aliasedName => _alias ?? 'sections_table';
  @override
  String get actualTableName => 'sections_table';
  @override
  VerificationContext validateIntegrity(Insertable<Sections> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sections map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sections(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
    );
  }

  @override
  $SectionsTableTable createAlias(String alias) {
    return $SectionsTableTable(attachedDatabase, alias);
  }
}

class Sections extends DataClass implements Insertable<Sections> {
  final int id;
  final String title;
  const Sections({required this.id, required this.title});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    return map;
  }

  SectionsTableCompanion toCompanion(bool nullToAbsent) {
    return SectionsTableCompanion(
      id: Value(id),
      title: Value(title),
    );
  }

  factory Sections.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sections(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
    };
  }

  Sections copyWith({int? id, String? title}) => Sections(
        id: id ?? this.id,
        title: title ?? this.title,
      );
  @override
  String toString() {
    return (StringBuffer('Sections(')
          ..write('id: $id, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sections && other.id == this.id && other.title == this.title);
}

class SectionsTableCompanion extends UpdateCompanion<Sections> {
  final Value<int> id;
  final Value<String> title;
  const SectionsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
  });
  SectionsTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
  }) : title = Value(title);
  static Insertable<Sections> custom({
    Expression<int>? id,
    Expression<String>? title,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
    });
  }

  SectionsTableCompanion copyWith({Value<int>? id, Value<String>? title}) {
    return SectionsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SectionsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }
}

class $TasksTableTable extends TasksTable
    with TableInfo<$TasksTableTable, Tasks> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _durationMeta =
      const VerificationMeta('duration');
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
      'duration', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<bool> status =
      GeneratedColumn<bool>('status', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("status" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  @override
  late final GeneratedColumn<bool> isDone =
      GeneratedColumn<bool>('is_done', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_done" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _sectionMeta =
      const VerificationMeta('section');
  @override
  late final GeneratedColumn<int> section = GeneratedColumn<int>(
      'section', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES sections_table (id)'));
  static const VerificationMeta _completedDateMeta =
      const VerificationMeta('completedDate');
  @override
  late final GeneratedColumn<DateTime> completedDate =
      GeneratedColumn<DateTime>('completed_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, position, duration, status, isDone, section, completedDate];
  @override
  String get aliasedName => _alias ?? 'tasks_table';
  @override
  String get actualTableName => 'tasks_table';
  @override
  VerificationContext validateIntegrity(Insertable<Tasks> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(_durationMeta,
          duration.isAcceptableOrUnknown(data['duration']!, _durationMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('is_done')) {
      context.handle(_isDoneMeta,
          isDone.isAcceptableOrUnknown(data['is_done']!, _isDoneMeta));
    }
    if (data.containsKey('section')) {
      context.handle(_sectionMeta,
          section.isAcceptableOrUnknown(data['section']!, _sectionMeta));
    } else if (isInserting) {
      context.missing(_sectionMeta);
    }
    if (data.containsKey('completed_date')) {
      context.handle(
          _completedDateMeta,
          completedDate.isAcceptableOrUnknown(
              data['completed_date']!, _completedDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tasks map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tasks(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      duration: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}status'])!,
      isDone: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_done'])!,
      section: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}section'])!,
      completedDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}completed_date']),
    );
  }

  @override
  $TasksTableTable createAlias(String alias) {
    return $TasksTableTable(attachedDatabase, alias);
  }
}

class Tasks extends DataClass implements Insertable<Tasks> {
  final int id;
  final String title;
  final int position;
  final int duration;
  final bool status;
  final bool isDone;
  final int section;
  final DateTime? completedDate;
  const Tasks(
      {required this.id,
      required this.title,
      required this.position,
      required this.duration,
      required this.status,
      required this.isDone,
      required this.section,
      this.completedDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['position'] = Variable<int>(position);
    map['duration'] = Variable<int>(duration);
    map['status'] = Variable<bool>(status);
    map['is_done'] = Variable<bool>(isDone);
    map['section'] = Variable<int>(section);
    if (!nullToAbsent || completedDate != null) {
      map['completed_date'] = Variable<DateTime>(completedDate);
    }
    return map;
  }

  TasksTableCompanion toCompanion(bool nullToAbsent) {
    return TasksTableCompanion(
      id: Value(id),
      title: Value(title),
      position: Value(position),
      duration: Value(duration),
      status: Value(status),
      isDone: Value(isDone),
      section: Value(section),
      completedDate: completedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(completedDate),
    );
  }

  factory Tasks.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tasks(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      position: serializer.fromJson<int>(json['position']),
      duration: serializer.fromJson<int>(json['duration']),
      status: serializer.fromJson<bool>(json['status']),
      isDone: serializer.fromJson<bool>(json['isDone']),
      section: serializer.fromJson<int>(json['section']),
      completedDate: serializer.fromJson<DateTime?>(json['completedDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'position': serializer.toJson<int>(position),
      'duration': serializer.toJson<int>(duration),
      'status': serializer.toJson<bool>(status),
      'isDone': serializer.toJson<bool>(isDone),
      'section': serializer.toJson<int>(section),
      'completedDate': serializer.toJson<DateTime?>(completedDate),
    };
  }

  Tasks copyWith(
          {int? id,
          String? title,
          int? position,
          int? duration,
          bool? status,
          bool? isDone,
          int? section,
          Value<DateTime?> completedDate = const Value.absent()}) =>
      Tasks(
        id: id ?? this.id,
        title: title ?? this.title,
        position: position ?? this.position,
        duration: duration ?? this.duration,
        status: status ?? this.status,
        isDone: isDone ?? this.isDone,
        section: section ?? this.section,
        completedDate:
            completedDate.present ? completedDate.value : this.completedDate,
      );
  @override
  String toString() {
    return (StringBuffer('Tasks(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('position: $position, ')
          ..write('duration: $duration, ')
          ..write('status: $status, ')
          ..write('isDone: $isDone, ')
          ..write('section: $section, ')
          ..write('completedDate: $completedDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, position, duration, status, isDone, section, completedDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tasks &&
          other.id == this.id &&
          other.title == this.title &&
          other.position == this.position &&
          other.duration == this.duration &&
          other.status == this.status &&
          other.isDone == this.isDone &&
          other.section == this.section &&
          other.completedDate == this.completedDate);
}

class TasksTableCompanion extends UpdateCompanion<Tasks> {
  final Value<int> id;
  final Value<String> title;
  final Value<int> position;
  final Value<int> duration;
  final Value<bool> status;
  final Value<bool> isDone;
  final Value<int> section;
  final Value<DateTime?> completedDate;
  const TasksTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.position = const Value.absent(),
    this.duration = const Value.absent(),
    this.status = const Value.absent(),
    this.isDone = const Value.absent(),
    this.section = const Value.absent(),
    this.completedDate = const Value.absent(),
  });
  TasksTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required int position,
    this.duration = const Value.absent(),
    this.status = const Value.absent(),
    this.isDone = const Value.absent(),
    required int section,
    this.completedDate = const Value.absent(),
  })  : title = Value(title),
        position = Value(position),
        section = Value(section);
  static Insertable<Tasks> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int>? position,
    Expression<int>? duration,
    Expression<bool>? status,
    Expression<bool>? isDone,
    Expression<int>? section,
    Expression<DateTime>? completedDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (position != null) 'position': position,
      if (duration != null) 'duration': duration,
      if (status != null) 'status': status,
      if (isDone != null) 'is_done': isDone,
      if (section != null) 'section': section,
      if (completedDate != null) 'completed_date': completedDate,
    });
  }

  TasksTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<int>? position,
      Value<int>? duration,
      Value<bool>? status,
      Value<bool>? isDone,
      Value<int>? section,
      Value<DateTime?>? completedDate}) {
    return TasksTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      isDone: isDone ?? this.isDone,
      section: section ?? this.section,
      completedDate: completedDate ?? this.completedDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (status.present) {
      map['status'] = Variable<bool>(status.value);
    }
    if (isDone.present) {
      map['is_done'] = Variable<bool>(isDone.value);
    }
    if (section.present) {
      map['section'] = Variable<int>(section.value);
    }
    if (completedDate.present) {
      map['completed_date'] = Variable<DateTime>(completedDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('position: $position, ')
          ..write('duration: $duration, ')
          ..write('status: $status, ')
          ..write('isDone: $isDone, ')
          ..write('section: $section, ')
          ..write('completedDate: $completedDate')
          ..write(')'))
        .toString();
  }
}

class SectionTaskCountData extends DataClass {
  final String title;
  final int? itemCount;
  const SectionTaskCountData({required this.title, this.itemCount});
  factory SectionTaskCountData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SectionTaskCountData(
      title: serializer.fromJson<String>(json['title']),
      itemCount: serializer.fromJson<int?>(json['itemCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'title': serializer.toJson<String>(title),
      'itemCount': serializer.toJson<int?>(itemCount),
    };
  }

  SectionTaskCountData copyWith(
          {String? title, Value<int?> itemCount = const Value.absent()}) =>
      SectionTaskCountData(
        title: title ?? this.title,
        itemCount: itemCount.present ? itemCount.value : this.itemCount,
      );
  @override
  String toString() {
    return (StringBuffer('SectionTaskCountData(')
          ..write('title: $title, ')
          ..write('itemCount: $itemCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(title, itemCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SectionTaskCountData &&
          other.title == this.title &&
          other.itemCount == this.itemCount);
}

class $SectionTaskCountView
    extends ViewInfo<$SectionTaskCountView, SectionTaskCountData>
    implements HasResultSet {
  final String? _alias;
  @override
  final _$AppDatabase attachedDatabase;
  $SectionTaskCountView(this.attachedDatabase, [this._alias]);
  $TasksTableTable get tasks => attachedDatabase.tasksTable.createAlias('t0');
  $SectionsTableTable get sections =>
      attachedDatabase.sectionsTable.createAlias('t1');
  @override
  List<GeneratedColumn> get $columns => [title, itemCount];
  @override
  String get aliasedName => _alias ?? entityName;
  @override
  String get entityName => 'section_task_count';
  @override
  String? get createViewStmt => null;
  @override
  $SectionTaskCountView get asDslTable => this;
  @override
  SectionTaskCountData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SectionTaskCountData(
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      itemCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_count']),
    );
  }

  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      generatedAs: GeneratedAs(sections.title, false),
      type: DriftSqlType.string);
  late final GeneratedColumn<int> itemCount = GeneratedColumn<int>(
      'item_count', aliasedName, true,
      generatedAs: GeneratedAs(tasks.id.count(), false),
      type: DriftSqlType.int);
  @override
  $SectionTaskCountView createAlias(String alias) {
    return $SectionTaskCountView(attachedDatabase, alias);
  }

  @override
  Query? get query =>
      (attachedDatabase.selectOnly(sections)..addColumns($columns))
          .join([innerJoin(tasks, tasks.section.equalsExp(sections.id))]);
  @override
  Set<String> get readTables => const {'tasks_table', 'sections_table'};
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $SectionsTableTable sectionsTable = $SectionsTableTable(this);
  late final $TasksTableTable tasksTable = $TasksTableTable(this);
  late final $SectionTaskCountView sectionTaskCount =
      $SectionTaskCountView(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [sectionsTable, tasksTable, sectionTaskCount];
}
