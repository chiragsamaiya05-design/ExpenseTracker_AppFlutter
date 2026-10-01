import 'package:flutter/material.dart';

class SocialLoginSection extends StatelessWidget {
  final VoidCallback? onGooglePressed;

  const SocialLoginSection({
    super.key,
    this.onGooglePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.grey.shade300,
                thickness: 1,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Or login with',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ),

            Expanded(
              child: Divider(
                color: Colors.grey.shade300,
                thickness: 1,
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        // Google button
        SizedBox(
          width: 52,
          height: 48,
          child: OutlinedButton(
            onPressed: onGooglePressed,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: Colors.white,
              side: const BorderSide(
                color: Color(0xFFD9DCE5),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'G',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4285F4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}