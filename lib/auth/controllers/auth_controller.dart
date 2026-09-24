import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository repository;

  AuthController({
    required this.repository,
  });

  UserModel? currentUser;

  String? pendingPhone;

  bool isLoading = false;
  bool isLoggedIn = false;

  String? errorMessage;

  // Temporary hardcoded OTP
  static const String hardcodedOtp = '123456';

  // Step 1: Enter phone number
  void setPhoneNumber(String phone) {
    pendingPhone = phone;
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
      // Check if user already exists
      UserModel? user =
      await repository.getUserByPhone(pendingPhone!);

      // If user doesn't exist, create account
      if (user == null) {
        final newUser = UserModel(
          phone: pendingPhone!,
          createdAt: DateTime.now(),
        );

        final userId = await repository.createUser(newUser);

        user = UserModel(
          id: userId,
          phone: newUser.phone,
          createdAt: newUser.createdAt,
        );
      }

      currentUser = user;
      isLoggedIn = true;

      return true;
    } catch (e, stackTrace) {
      debugPrint('AUTH ERROR: $e');
      debugPrint('STACK TRACE: $stackTrace');

      errorMessage = 'Authentication failed: $e';

      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Logout
  void logout() {
    currentUser = null;
    pendingPhone = null;
    isLoggedIn = false;
    errorMessage = null;

    notifyListeners();
  }
}