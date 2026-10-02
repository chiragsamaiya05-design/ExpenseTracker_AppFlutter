import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../widgets/auth_header.dart';
import '../widgets/login_button.dart';
import '../widgets/phone_number_field.dart';
import 'login_screen.dart';
import 'otp_verification_screen.dart';
import '../widgets/password_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String? phoneError;
  String? passwordError;
  String? confirmPasswordError;


  // PHONE VALIDATION
  bool _validateSignup() {
    final phone = phoneController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    setState(() {
      phoneError = null;
      passwordError = null;
      confirmPasswordError = null;
    });

    bool isValid = true;

    if (phone.isEmpty) {
      setState(() {
        phoneError = 'Please enter your mobile number';
      });
      isValid = false;
    } else if (phone.length != 10) {
      setState(() {
        phoneError = 'Enter a valid 10-digit mobile number';
      });
      isValid = false;
    }

    if (password.isEmpty) {
      setState(() {
        passwordError = 'Please create a password';
      });
      isValid = false;
    } else if (password.length < 6) {
      setState(() {
        passwordError = 'Password must be at least 6 characters';
      });
      isValid = false;
    }

    if (confirmPassword.isEmpty) {
      setState(() {
        confirmPasswordError = 'Please confirm your password';
      });
      isValid = false;
    } else if (password != confirmPassword) {
      setState(() {
        confirmPasswordError = 'Passwords do not match';
      });
      isValid = false;
    }

    return isValid;
  }


  // CONTINUE SIGNUP
  void _continueSignup() {
    if (!_validateSignup()) {
      return;
    }
    final phone = phoneController.text.trim();
    final password = passwordController.text;
    context.read<AuthController>().startSignup(
      phone,
      password,
    );
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
  // DISPOSE
  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // BUILD
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

                  // HEADER
                  const AuthHeader(
                    subtitle: 'Create your Account',
                  ),

                  const SizedBox(height: 30),

                  // PHONE
                  PhoneNumberField(
                    controller: phoneController,
                    errorText: phoneError,
                  ),
                  const SizedBox(height: 18),

                  PasswordField(
                    controller: passwordController,
                    errorText: passwordError,
                  ),

                  const SizedBox(height: 18),

                  PasswordField(
                    controller: confirmPasswordController,
                    errorText: confirmPasswordError,
                  ),

                  const SizedBox(height: 20),

                  // CONTINUE
                  LoginButton(
                    text: 'Continue',
                    onPressed: _continueSignup,
                  ),

                  const SizedBox(height: 24),

                  // LOGIN
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