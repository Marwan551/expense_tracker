import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DataClassName('ExpenseEntity')
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get amount => integer()();
  TextColumn get category => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text().nullable()();
}

@DriftDatabase(tables: [Expenses])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'expenses_database');
  }
}
