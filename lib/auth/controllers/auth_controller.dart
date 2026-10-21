import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../services/auth_session.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository repository;
  final AuthSession session;


  AuthController({
    required this.repository,
    required this.session,
  });

  UserModel? currentUser;

  String? pendingPhone;
  String? pendingPassword;

  bool isLoading = false;
  bool isLoggedIn = false;
  bool isSignupFlow = false;


  String? errorMessage;


  static const String hardcodedOtp = '123456';

  void startLogin(String phone,) {
    pendingPhone = phone.trim();
    pendingPassword = null;
    isSignupFlow = false;
    errorMessage = null;

    notifyListeners();
  }

  void startSignup(String phone,String password) {
    pendingPhone = phone.trim();
    pendingPassword = password;
    isSignupFlow = true;
    errorMessage = null;

    notifyListeners();
  }


  Future<bool> verifyOtp(String otp) async {
    errorMessage = null;

    // Step 1: Validate OTP
    if (otp != hardcodedOtp) {
      errorMessage = 'Invalid OTP';
      notifyListeners();
      return false;
    }

    // Step 2: Validate phone number
    final phone = pendingPhone?.trim();

    if (phone == null || phone.isEmpty) {
      errorMessage = 'Phone number not found';
      notifyListeners();
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      // SIGNUP FLOW
      if (isSignupFlow) {
        // Check for an existing local account.
        final existingUser = await repository.getUserByPhone(phone);

        if (existingUser != null) {
          errorMessage =
          'An account already exists with this number. Please log in.';
          return false;
        }

        // Validate password.
        final password = pendingPassword;

        if (password == null || password.isEmpty) {
          errorMessage = 'Password is required.';
          return false;
        }

        // Create the account using the FastAPI backend.
        // This method should also log in and create/link the local user.
        final newUser = await repository.createAccountWithBackend(
          phone: phone,
          password: password,
        );

        if (newUser.id == null) {
          errorMessage = 'Unable to create the local user session.';
          return false;
        }

        currentUser = newUser;
        isLoggedIn = true;

        await session.saveUserId(newUser.id!);

        pendingPassword = null;

        return true;
      }

      // LOGIN FLOW
      // This is OTP login, not password login.
      // The OTP is currently hardcoded, so this is not real phone verification.
      final existingUser = await repository.getUserByPhone(phone);

      if (existingUser == null) {
        errorMessage =
        'No local account found with this number. Please sign up first.';
        return false;
      }

      currentUser = existingUser;
      isLoggedIn = true;

      if (existingUser.id != null) {
        await session.saveUserId(existingUser.id!);
      }

      pendingPassword = null;

      return true;
    } catch (e, stackTrace) {
      debugPrint('========== AUTHENTICATION ERROR ==========');
      debugPrint('ERROR: $e');
      debugPrint('STACK TRACE: $stackTrace');
      debugPrint('==========================================');

      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool>restoreSession() async{
    isLoading = true;
    errorMessage = null;
    try{
      final userId = await session.getUserId();

      if(userId == null){
        isLoggedIn = false;
        return false;
      }
      final user = await repository.getUserById(userId);

      if (user == null) {
        await session.clearSession();

        isLoggedIn = false;
        currentUser = null;

        return false;
      }

      currentUser = user;
      pendingPhone = user.phone;
      isLoggedIn = true;

      return true;
    }catch (e, stackTrace) {
      debugPrint('SESSION ERROR: $e');
      debugPrint('STACK TRACE: $stackTrace');

      await session.clearSession();

      currentUser = null;
      isLoggedIn = false;

      errorMessage =
      'Unable to restore your session.';

      return false;
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void> logout() async {
    await repository.tokenStorage.clearAccessToken();
    await session.clearSession();

    currentUser = null;
    pendingPhone = null;
    pendingPassword = null;

    isLoggedIn = false;
    isSignupFlow = false;

    errorMessage = null;

    notifyListeners();
  }


  Future<bool> loginWithPassword(
      String phone,
      String password,
      ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final normalizedPhone = phone.trim();

      // Authenticate with the backend and save the access token.
      final result = await repository.loginWithBackend(
        phone: normalizedPhone,
        password: password,
      );

      final profile = result['profile'] as Map<String, dynamic>;
      final serverUserId = profile['id'];

      if (serverUserId is! String || serverUserId.isEmpty) {
        throw Exception('The server returned an invalid user ID.');
      }

      // Find or create the local user and link the backend account.
      final localUser = await repository.getOrCreateLocalUser(
        phone: normalizedPhone,
        serverUserId: serverUserId,
      );

      final localId = localUser.id;

      if (localId == null) {
        throw Exception('Local user ID is missing.');
      }

      // Update the local password hash.
      final passwordHash = repository.hashPassword(password);

      final rowsUpdated = await repository.updatePassword(
        localId,
        passwordHash,
      );

      if (rowsUpdated == 0) {
        throw Exception(
          'Backend login succeeded, but the local password could not be updated.',
        );
      }

      // Reload the user after updating the database.
      final refreshedUser = await repository.getUserById(localId);

      if (refreshedUser == null) {
        throw Exception('Unable to reload the local user after login.');
      }

      currentUser = refreshedUser;
      pendingPhone = normalizedPhone;
      pendingPassword = null;
      isLoggedIn = true;

      await session.saveUserId(localId);

      return true;
    } catch (e, stackTrace) {
      debugPrint('BACKEND LOGIN ERROR: $e');
      debugPrint('STACK TRACE: $stackTrace');

      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<bool>setPassword(String password)async{
    errorMessage = null;

    if(currentUser == null|| currentUser!.id == null){
      errorMessage = 'User session not found.';
      notifyListeners();
      return false;
    }
    if(password.length<8){
      errorMessage= 'Password must be at least 8 characters.';
      notifyListeners();
      return false;
    }
    isLoading = true;
    notifyListeners();

    try{
      final hashedPassword = repository.hashPassword(password);

      final updateRows = await repository.updatePassword(currentUser!.id!, hashedPassword);

      if(updateRows == 0){
        errorMessage = 'Unable to set password.';
        return false;
      }
      currentUser = UserModel(
        id: currentUser!.id,
        phone: currentUser!.phone,
        passwordHash: hashedPassword,
        createdAt: currentUser!.createdAt,
      );
      return true;

    }catch(e){
      debugPrint('SET PASSWORD ERROR: $e');
      errorMessage = 'Unable to set password. Please try again.';
      return false;
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }



  Future<void> resetAuthenticationData() async {
    await repository.resetDatabase();
    await session.clearSession();

    currentUser = null;
    pendingPhone = null;
    pendingPassword = null;
    isLoggedIn = false;
    isSignupFlow = false;
    errorMessage = null;

    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}