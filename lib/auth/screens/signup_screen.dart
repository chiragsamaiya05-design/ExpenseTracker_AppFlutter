import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../widgets/auth_header.dart';
import '../widgets/login_button.dart';
import '../widgets/phone_number_field.dart';
import 'login_screen.dart';
import 'otp_verification_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController phoneController =
  TextEditingController();

  String? phoneError;

  // =========================
  // PHONE VALIDATION
  // =========================

  bool _validatePhone() {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      setState(() {
        phoneError = 'Please enter your mobile number';
      });

      return false;
    }

    if (phone.length != 10) {
      setState(() {
        phoneError = 'Enter a valid 10-digit mobile number';
      });

      return false;
    }

    setState(() {
      phoneError = null;
    });

    return true;
  }

  // =========================
  // CONTINUE SIGNUP
  // =========================

  void _continueSignup() {
    if (!_validatePhone()) {
      return;
    }

    final phone = phoneController.text.trim();

    // Tell AuthController this is a signup flow.
    context.read<AuthController>().startSignup(phone);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpVerificationScreen(
          phone: phone,
          isSignup: true,
        ),
      ),
    );
  }

  // =========================
  // DISPOSE
  // =========================

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  // =========================
  // BUILD
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),

      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior.onDrag,

          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),

          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 460,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // =========================
                  // HEADER
                  // =========================

                  const AuthHeader(
                    subtitle: 'Create your Account',
                  ),

                  const SizedBox(height: 30),

                  // =========================
                  // PHONE
                  // =========================

                  PhoneNumberField(
                    controller: phoneController,
                    errorText: phoneError,
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // CONTINUE
                  // =========================

                  LoginButton(
                    text: 'Continue',
                    onPressed: _continueSignup,
                  ),

                  const SizedBox(height: 24),

                  // =========================
                  // LOGIN
                  // =========================

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const LoginScreen(),
                            ),
                          );
                        },

                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                        ),

                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF263AA5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}