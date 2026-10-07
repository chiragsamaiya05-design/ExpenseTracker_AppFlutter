import 'package:flutter/material.dart';

class AuthHeader  extends StatelessWidget{
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    this.title = 'Expense Tracker',
    this.subtitle = 'Login to your Account',
});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFF4F46A5),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.account_balance_wallet_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),

        const SizedBox(height: 12,),

        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: .w700,
            color: Color(0xFF4F46A5),
          ),
        ),
        const SizedBox(height: 42,),

        Align(
          alignment: .centerLeft,
          child: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: .w600,
              color: Color(0xFF222222),
            ),
          ),
        )
      ],
    );
  }
}