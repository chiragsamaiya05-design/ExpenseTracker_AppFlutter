import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 4,
        onCreate: (db, version) async {
          await db.execute('''
        `CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          phone TEXT UNIQUE NOT NULL,
          password_hash TEXT,
          server_user_id TEXT,
          created_at TEXT NOT NULL
        )
      ''');


        },


        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 3) {
            await db.execute('''
            ALTER TABLE users
            ADD COLUMN password_hash TEXT
          ''');
          }
          if (oldVersion < 4) {
            await db.execute('''
            ALTER TABLE users
            ADD COLUMN server_user_id TEXT
          ''');
          }
        },
      ),
    );
  }

  Future<int> insertUser(UserModel user) async {
    final db = await database;

    final data = user.toMap();

    final userId = await db.insert(
      'users',
      data,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
    return userId;
  }

  Future<int> updateServerUserId(
      int localUserId,
      String serverUserId,
      ) async {
    final db = await database;

    return db.update(
      'users',
      {
        'server_user_id': serverUserId,
      },
      where: 'id = ?',
      whereArgs: [localUserId],
    );
  }

  Future<String?> getServerUserId(int localUserId) async {
    final db = await database;

    final result = await db.query(
      'users',
      columns: ['server_user_id'],
      where: 'id = ?',
      whereArgs: [localUserId],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first['server_user_id'] as String?;
  }

  Future<UserModel?> getUserByPhone(String phone) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'phone = ?',
      whereArgs: [phone],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return UserModel.fromMap(result.first);
  }

  Future<UserModel?> getUserById(int id) async {
    final db = await database;

    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return UserModel.fromMap(result.first);
  }

  Future<int> updatePassword(int userId,String passwordHash)async{
    final db = await database;

    return await db.update('users',
        {
          'password_hash':passwordHash,
        },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();

    final path = join(
      dbPath,
      'expense_tracker_users.db',
    );

    await databaseFactory.deleteDatabase(path);

    _database = null;

    debugPrint('User database deleted.');
  }

  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();

    final path = join(
      dbPath,
      'expense_tracker_users.db',
    );

    if (_database != null) {
      await _database!.close();
      _database = null;
    }

    await databaseFactory.deleteDatabase(path);

    debugPrint('USER DATABASE RESET: $path');
  }


}