import '../database/user_database.dart';
import '../models/user_model.dart';

class AuthRepository {
  final UserDatabase database;

  AuthRepository({
    required this.database,
  });

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
}