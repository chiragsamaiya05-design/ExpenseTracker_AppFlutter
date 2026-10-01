import 'package:flutter/material.dart';
import 'otp_input.dart';

class OtpSection extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final VoidCallback? onResend;
  final VoidCallback? onCompleted;
  final VoidCallback? onChanged;
  final int resendSeconds;
  final String? errorText;

  const OtpSection({
    super.key,
    required this.controllers,
    required this.focusNodes,
    required this.resendSeconds,
    this.onCompleted,
    this.onChanged,
    this.onResend,
    this. errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter OTP',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),

        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            controllers.length,
                (index) {
              return OtpInput(
                controller: controllers[index],
                focusNode: focusNodes[index],
                nextFocusNode:
                index < controllers.length-1 ? focusNodes[index + 1] : null,
                previousFocusNode:
                index > 0 ? focusNodes[index - 1] : null,
                onCompleted:
                index== controllers.length-1 ? onCompleted:null,
                onChanged: onChanged,
              );
            },
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            errorText!,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],

        const SizedBox(height: 10),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: resendSeconds == 0 ? onResend:null,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child:  Text(
              resendSeconds>0
                  ?'Resend OTP in ${resendSeconds}s'
                  : 'Resend OTP',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: resendSeconds>0
                      ? Colors.grey
                    : const Color(0xFF263AA5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}