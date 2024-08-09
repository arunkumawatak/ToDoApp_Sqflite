import 'dart:developer';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sql_todo_app/models/task_Model.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  final String _taskTableName = "task";
  final String _taskIdColumnName = "id";
  final String _taskContentColumnName = "content";
  final String _taskStatusColumnName = "status";
  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(databasePath, onCreate: (db, version) {
      db.execute(
          """CREATE TABLE $_taskTableName ($_taskIdColumnName INTEGER PRIMARY KEY, $_taskContentColumnName TEXT NOT NULL,$_taskStatusColumnName INTEGER NOT NULL)""");
    }, version: 1);
    return database;
  }

//add task
  void addTask(String content) async {
    final db = await database;
    await db.insert(_taskTableName,
        {_taskContentColumnName: content, _taskStatusColumnName: 0});
  }

//get task
  Future<List<TaskModel>> getTask() async {
    final db = await database;
    final data = await db.query(_taskTableName);
    log("data: $data");
    List<TaskModel> _tasks = data
        .map((e) => TaskModel(
            content: e["content"] as String,
            id: e["id"] as int,
            status: e["status"] as int))
        .toList();
    return _tasks;
  }

  void updateTaskStatus(int id, int status) async {
    final db = await database;
    await db.update(
      _taskTableName,
      {_taskStatusColumnName: status},
      where: "id = ?",
      whereArgs: [
        id,
      ],
    );
  }

  void deleteTask(
    int id,
  ) async {
    final db = await database;
    await db.delete(
      _taskTableName,
      where: "id = ?",
      whereArgs: [
        id,
      ],
    );
  }
}
