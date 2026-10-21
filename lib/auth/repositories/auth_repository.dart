import 'package:bcrypt/bcrypt.dart';

import '../database/user_database.dart';
import '../models/user_model.dart';
import '../services/auth_api_service.dart';
import '../services/auth_token_storage.dart';

class AuthRepository {
  final UserDatabase database;
  final AuthApiService api;
  final AuthTokenStorage tokenStorage;

  AuthRepository({
    required this.database,
    required this.api,
    required this.tokenStorage
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

  Future<int> updateServerUserId(int localUserId, String serverUserId,) async {
    return database.updateServerUserId(
      localUserId,
      serverUserId,
    );
  }

  Future<Map<String, dynamic>> loginWithBackend({required String phone, required String password,}) async {
    // Authenticate against the FastAPI backend.
    final response = await api.login(
      phone: phone.trim(),
      password: password,
    );

    final token = response['access_token'];

    if (token is! String || token.isEmpty) {
      throw Exception(
        'The server did not return an access token.',
      );
    }

    // Store the access token securely.
    await tokenStorage.saveAccessToken(token);

    try {
      // Fetch the authenticated user's server profile.
      final profile = await api.getCurrentUser(
        accessToken: token,
      );

      final serverUserId = profile['id'];

      if (serverUserId is! String || serverUserId.isEmpty) {
        throw Exception(
          'The server returned an invalid user ID.',
        );
      }

      // Look up the existing local user.
      final localUser = await getUserByPhone(phone.trim());

      // Associate the local user with the server account if
      // the user already exists locally.
      if (localUser != null && localUser.id != null) {
        await updateServerUserId(
          localUser.id!,
          serverUserId,
        );
      }

      return {
        'access_token': token,
        'profile': profile,
      };
    } catch (_) {
      // Remove the token if profile retrieval or local
      // account association fails.
      await tokenStorage.clearAccessToken();
      rethrow;
    }
  }

  Future<UserModel> getOrCreateLocalUser({required String phone, required String serverUserId,}) async {
    final normalizedPhone = phone.trim();

    final existingUser = await getUserByPhone(normalizedPhone);

    if (existingUser != null) {
      final localId = existingUser.id;

      if (localId == null) {
        throw Exception('Local user ID is missing.');
      }

      if (existingUser.serverUserId != null &&
          existingUser.serverUserId != serverUserId) {
        throw Exception(
          'This local account is linked to a different server account.',
        );
      }

      if (existingUser.serverUserId == null) {
        await updateServerUserId(localId, serverUserId);
      }

      return existingUser.copyWith(
        serverUserId: serverUserId,
      );
    }

    final newUser = UserModel(
      phone: normalizedPhone,
      serverUserId: serverUserId,
      passwordHash: null,
      createdAt: DateTime.now(),
    );

    final localId = await createUser(newUser);

    return newUser.copyWith(id: localId);
  }

  Future<UserModel> createAccountWithBackend({required String phone, required String password,}) async {
    final normalizedPhone = phone.trim();

    // Register the account on FastAPI.
    await api.signup(
      phone: normalizedPhone,
      password: password,
    );

    // Obtain an access token after signup.
    final loginResponse = await api.login(
      phone: normalizedPhone,
      password: password,
    );

    final token = loginResponse['access_token'];

    if (token is! String || token.isEmpty) {
      throw Exception(
        'Account created, but no access token was returned.',
      );
    }

    await tokenStorage.saveAccessToken(token);

    try {
      final profile = await api.getCurrentUser(
        accessToken: token,
      );

      final serverUserId = profile['id'];

      if (serverUserId is! String || serverUserId.isEmpty) {
        throw Exception('Invalid server user ID.');
      }

      return await getOrCreateLocalUser(
        phone: normalizedPhone,
        serverUserId: serverUserId,
      );
    } catch (_) {
      await tokenStorage.clearAccessToken();
      rethrow;
    }
  }
}