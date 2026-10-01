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

  bool isLoading = false;
  bool isLoggedIn = false;
  bool isSignupFlow = false;


  String? errorMessage;

  // Temporary hardcoded OTP
  static const String hardcodedOtp = '123456';

  void startLogin(String phone) {
    pendingPhone = phone.trim();
    isSignupFlow = false;
    errorMessage = null;

    notifyListeners();
  }


  // START SIGNUP
  void startSignup(String phone) {
    pendingPhone = phone.trim();
    isSignupFlow = true;
    errorMessage = null;

    notifyListeners();
  }

  // Step 2: Verify OTP
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

      // =========================
      // SIGNUP FLOW
      // =========================

      if (isSignupFlow) {
        if (existingUser != null) {
          errorMessage =
          'An account already exists with this number.';
          return false;
        }

        final newUser = UserModel(
          phone: phone,
          createdAt: DateTime.now(),
        );

        final userId = await repository.createUser(newUser);

        currentUser = UserModel(
          id: userId,
          phone: newUser.phone,
          createdAt: newUser.createdAt,
        );

        isLoggedIn = true;

        if (userId != null) {
          await session.saveUserId(userId);
        }

        return true;
      }

      // =========================
      // LOGIN FLOW
      // =========================

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

      return true;
    } catch (e, stackTrace) {
      debugPrint('AUTH ERROR: $e');
      debugPrint('STACK TRACE: $stackTrace');

      errorMessage = 'Authentication failed. Please try again.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  //check existing session

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