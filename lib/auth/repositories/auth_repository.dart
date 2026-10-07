import 'package:bcrypt/bcrypt.dart';

import '../database/user_database.dart';
import '../models/user_model.dart';

class AuthRepository {
  final UserDatabase database;

  AuthRepository({
    required this.database,
  });
  String hashPassword(String password) {
    return BCrypt.hashpw(
      password,
      BCrypt.gensalt(),
    );
  }

  bool verifyPasswordHash(String password, String passwordHash,) {
    return BCrypt.checkpw(
      password,
      passwordHash,
    );
  }

  Future<int> createUser(UserModel user) async {
    return await database.insertUser(user);
  }

  Future<UserModel?> getUserByPhone(String phone) async {
    return await database.getUserByPhone(phone);
  }

  Future<bool> isUserRegistered(String phone) async {
    final user = await getUserByPhone(phone);
    return user != null;
  }
  Future<UserModel?> getUserById(int id) async {
    return await database.getUserById(id);
  }

  Future<int> updatePassword(int userId, String passwordHash,) async {
    return await database.updatePassword(userId, passwordHash,);
  }

  Future<void> resetDatabase() async {
    await database.resetDatabase();
  }
}