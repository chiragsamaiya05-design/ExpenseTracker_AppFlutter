import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../widgets/auth_header.dart';
import '../widgets/forgot_password_button.dart';
import '../widgets/login_button.dart';
import '../widgets/login_method_selector.dart';
import '../widgets/password_field.dart';
import '../widgets/phone_number_field.dart';
import '../widgets/signup_prompt.dart';
import '../widgets/social_login_section.dart';

import 'otp_verification_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  bool isOtpSelected = false;

  String? phoneError;
  String? passwordError;



  final TextEditingController phoneController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();



  bool _validatePasswordLogin() {
    setState(() {
      phoneError = null;
      passwordError = null;
    });

    bool isValid = true;

    final phone = phoneController.text.trim();
    final password = passwordController.text;

    // Validate phone
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

    // Validate password
    if (password.isEmpty) {
      setState(() {
        passwordError = 'Please enter your password';
      });

      isValid = false;
    }

    return isValid;
  }



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



  void _sendOtp() {
    if (!_validatePhone()) {
      return;
    }

    final phone = phoneController.text.trim();

    // Tell AuthController that this is a login flow.
    context.read<AuthController>().startLogin(phone);

    // Move to reusable OTP screen.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpVerificationScreen(
          phone: phone,
          isSignup: false,
        ),
      ),
    );
  }


  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();

    super.dispose();
  }



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


                  const AuthHeader(),

                  const SizedBox(height: 30),



                  LoginMethodSelector(
                    isOtpSelected: isOtpSelected,

                    onPasswordSelected: () {
                      setState(() {
                        isOtpSelected = false;
                        phoneError = null;
                        passwordError = null;
                      });
                    },

                    onOtpSelected: () {
                      setState(() {
                        isOtpSelected = true;
                        phoneError = null;
                        passwordError = null;
                      });
                    },
                  ),

                  const SizedBox(height: 22),



                  PhoneNumberField(
                    controller: phoneController,
                    errorText: phoneError,
                  ),

                  const SizedBox(height: 18),



                  if (!isOtpSelected) ...[
                    PasswordField(
                      controller: passwordController,
                      errorText: passwordError,
                    ),

                    const SizedBox(height: 8),

                    ForgotPasswordButton(
                      onPressed: () {
                        debugPrint(
                          'Forgot password pressed',
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    LoginButton(
                      text: 'Sign in',
                      onPressed: () {
                        if (_validatePasswordLogin()) {
                          debugPrint(
                            'Password validation successful',
                          );
                        }
                      },
                    ),
                  ]



                  else ...[
                    LoginButton(
                      text: 'Send OTP',
                      onPressed: _sendOtp,
                    ),
                  ],

                  const SizedBox(height: 28),



                  SocialLoginSection(
                    onGooglePressed: () {
                      debugPrint(
                        'Google login pressed',
                      );
                    },
                  ),

                  const SizedBox(height: 24),



                  SignupPrompt(
                    onSignupPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const SignupScreen(),
                        ),
                      );
                    },
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