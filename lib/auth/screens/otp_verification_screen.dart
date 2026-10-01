import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../widgets/auth_header.dart';
import '../widgets/change_number_button.dart';
import '../widgets/login_button.dart';
import '../widgets/otp_section.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import '../../Screens/main_navigation_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phone;
  final bool isSignup;

  const OtpVerificationScreen({
    super.key,
    required this.phone,
    this.isSignup = false,
  });

  @override
  State<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState
    extends State<OtpVerificationScreen> {
  final List<TextEditingController> otpControllers =
  List.generate(
    6,
        (_) => TextEditingController(),
  );

  final List<FocusNode> otpFocusNodes =
  List.generate(
    6,
        (_) => FocusNode(),
  );

  Timer? _resendTimer;
  int resendSeconds = 30;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startResendTimer();

      if (mounted) {
        otpFocusNodes.first.requestFocus();
      }
    });
  }

  String _getOtp() {
    return otpControllers
        .map((controller) => controller.text)
        .join();
  }

  Future<void> _verifyOtp() async {
    final auth = context.read<AuthController>();

    if (auth.isLoading) {
      return;
    }

    final otp = _getOtp();

    if (otp.length != 6) {
      return;
    }

    final success = await auth.verifyOtp(otp);

    if (!mounted) {
      return;
    }

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(),
        ),
            (route) => false,
      );
    }
  }

  void _startResendTimer() {
    _resendTimer?.cancel();

    setState(() {
      resendSeconds = 30;
    });

    _resendTimer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (resendSeconds <= 1) {
          timer.cancel();

          setState(() {
            resendSeconds = 0;
          });
        } else {
          setState(() {
            resendSeconds--;
          });
        }
      },
    );
  }

  void _resendOtp() {
    if (resendSeconds > 0) {
      return;
    }

    final auth = context.read<AuthController>();

    if (widget.isSignup) {
      auth.startSignup(widget.phone);
    } else {
      auth.startLogin(widget.phone);
    }

    for (final controller in otpControllers) {
      controller.clear();
    }

    auth.clearError();

    _startResendTimer();

    otpFocusNodes.first.requestFocus();

    debugPrint('OTP resent to ${widget.phone}');
  }

  void _changeNumber() {
    _resendTimer?.cancel();

    for (final controller in otpControllers) {
      controller.clear();
    }

    context.read<AuthController>().clearError();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _resendTimer?.cancel();

    for (final controller in otpControllers) {
      controller.dispose();
    }

    for (final node in otpFocusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

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
                  AuthHeader(
                    subtitle: widget.isSignup
                        ? 'Verify your Account'
                        : 'Verify your Login',
                  ),

                  const SizedBox(height: 30),

                  Text(
                    'We sent a 6-digit OTP to',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    '+91 ${widget.phone}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF263AA5),
                    ),
                  ),

                  const SizedBox(height: 26),

                  OtpSection(
                    controllers: otpControllers,
                    focusNodes: otpFocusNodes,
                    resendSeconds: resendSeconds,
                    errorText: auth.errorMessage,
                    onResend: _resendOtp,
                    onCompleted: _verifyOtp,
                    onChanged: () {
                      if (auth.errorMessage != null) {
                        auth.clearError();
                      }
                    },
                  ),

                  const SizedBox(height: 18),

                  LoginButton(
                    text: widget.isSignup
                        ? 'Verify & Create Account'
                        : 'Verify & Login',
                    isLoading: auth.isLoading,
                    onPressed: _verifyOtp,
                  ),

                  const SizedBox(height: 14),

                  ChangeNumberButton(
                    onPressed: _changeNumber,
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