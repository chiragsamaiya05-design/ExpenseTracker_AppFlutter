import 'package:flutter/material.dart';

class LoginMethodSelector extends StatelessWidget {
  final bool isOtpSelected;
  final VoidCallback onPasswordSelected;
  final VoidCallback onOtpSelected;

  const LoginMethodSelector({
    super.key,
    required this.isOtpSelected,
    required this.onPasswordSelected,
    required this.onOtpSelected,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4F46A5);

    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE9ECF8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildOption(
              title: 'Password',
              selected: !isOtpSelected,
              onTap: onPasswordSelected,
              primaryColor: primaryColor,
            ),
          ),
          Expanded(
            child: _buildOption(
              title: 'OTP',
              selected: isOtpSelected,
              onTap: onOtpSelected,
              primaryColor: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required String title,
    required bool selected,
    required VoidCallback onTap,
    required Color primaryColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: selected
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? primaryColor : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}