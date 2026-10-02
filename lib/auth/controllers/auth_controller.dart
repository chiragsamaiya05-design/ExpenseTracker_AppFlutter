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

    if (otp != hardcodedOtp) {
      errorMessage = 'Invalid OTP';
      notifyListeners();
      return false;
    }

    if (pendingPhone == null || pendingPhone!.isEmpty) {
      errorMessage = 'Phone number not found';
      notifyListeners();
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      final phone = pendingPhone!;
      final existingUser =
      await repository.getUserByPhone(pendingPhone!);


      // SIGNUP FLOW
      if (isSignupFlow) {
        if (existingUser != null) {
          errorMessage =
          'An account already exists with this number.';
          return false;
        }
        if (pendingPassword == null || pendingPassword!.isEmpty) {
          errorMessage = 'Password is required.';
          return false;
        }
        final hashedPassword = repository.hashPassword(pendingPassword!);

        final newUser = UserModel(
          phone: phone,
          passwordHash: hashedPassword,
          createdAt: DateTime.now(),
        );

        final userId = await repository.createUser(newUser);

        currentUser = UserModel(
          id: userId,
          phone: newUser.phone,
          passwordHash: newUser.passwordHash,
          createdAt: newUser.createdAt,
        );

        isLoggedIn = true;
        await session.saveUserId(userId);
        pendingPassword = null;
        return true;
      }


      // LOGIN FLOW
      if (existingUser == null) {
        errorMessage =
        'No account found with this number. Please sign up first.';
        return false;
      }
      currentUser = existingUser;
      isLoggedIn = true;

      if (existingUser.id != null) {
        await session.saveUserId(existingUser.id!);
      }
      pendingPassword = null;
      return true;
    } catch (e) {
      errorMessage = 'Authentication failed. Please try again.';
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
    await session.clearSession();

    currentUser = null;
    pendingPhone = null;
    pendingPassword = null;

    isLoggedIn = false;
    isSignupFlow = false;

    errorMessage = null;

    notifyListeners();
  }

  Future<bool> loginWithPassword(String phone, String password,) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await repository.getUserByPhone(phone.trim());

      if (user == null) {
        errorMessage = 'No account found with this number.';
        return false;
      }

      if (user.passwordHash == null || user.passwordHash!.isEmpty) {
        errorMessage = 'This account does not have a password.';
        return false;
      }

      final valid = await repository.verifyPasswordHash(
        password,
        user.passwordHash!,
      );

      if (!valid) {
        errorMessage = 'Incorrect password.';
        return false;
      }

      currentUser = user;
      pendingPhone = user.phone;
      pendingPassword = null;
      isLoggedIn = true;

      if (user.id != null) {
        await session.saveUserId(user.id!);
      }

      return true;
    } catch (e) {
      errorMessage = 'Login failed. Please try again.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}