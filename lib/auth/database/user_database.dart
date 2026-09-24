import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../models/user_model.dart';

class UserDatabase {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();

    final path = join(
      dbPath,
      'expense_tracker_users.db',
    );

    return await databaseFactoryFfi.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE users (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              phone TEXT UNIQUE NOT NULL,
              created_at TEXT NOT NULL
            )
          ''');
        },
      ),
    );
  }

  Future<int> insertUser(UserModel user) async {
    final db = await database;

    final data = user.toMap();

    debugPrint('================ INSERT USER ================');
    debugPrint('User data: $data');
    debugPrint('=============================================');

    return await db.insert(
      'users',
      data,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<UserModel?> getUserByPhone(String phone) async {
    final db = await database;

    final result = await db.query(
      'users',
      where: 'phone = ?',
      whereArgs: [phone],
      limit: 1,
    );

    debugPrint('================ USER DATABASE ================');
    debugPrint('Searching phone: $phone');
    debugPrint('Query result: $result');
    debugPrint('================================================');

    if (result.isEmpty) {
      return null;
    }

    return UserModel.fromMap(result.first);
  }
}