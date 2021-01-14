
import 'package:moor_flutter/moor_flutter.dart';
part 'database.g.dart';

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get address => text()();

  TextColumn get email => text()();

}

@UseMoor(tables: [Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
      path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;

  static AppDatabase database;

  static AppDatabase getDatabase() {
    if (database == null) {
      database = AppDatabase();
    }
    return database;
  }

  Future insertAdds(Insertable<Task> task) => into(tasks).insert(task);
  Future deleteAll() => delete(tasks).go();

  Stream<List<Task>> watchAdds() => select(tasks).watch();
 // Future<List<Task>> getAdds() => select(tasks).get();

  Future<List<Task>> getAdds(String email) {
    return (select(tasks)..where((t) => t.email.equals(email))).get();
  }

}
