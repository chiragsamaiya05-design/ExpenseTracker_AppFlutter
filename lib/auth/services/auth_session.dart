import 'package:shared_preferences/shared_preferences.dart';

class AuthSession {
  static const String _userIdKey = 'logged_in_user_id';

  Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(
      _userIdKey,
      userId,
    );
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_userIdKey);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_userIdKey);
  }
}