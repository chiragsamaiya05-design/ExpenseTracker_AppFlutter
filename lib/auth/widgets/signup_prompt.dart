import 'package:flutter/material.dart';

class SignupPrompt extends StatelessWidget {
  final VoidCallback onSignupPressed;

  const SignupPrompt({
    super.key,
    required this.onSignupPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        TextButton(
          onPressed: onSignupPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Sign up',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4F46A5),
            ),
          ),
        ),
      ],
    );
  }
}