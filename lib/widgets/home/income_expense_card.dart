import 'package:flutter/material.dart';

class IncomeExpenseCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final VoidCallback? onTap;

  const IncomeExpenseCard({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isIncome = title == 'Income';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),

      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: color,

        shape: RoundedRectangleBorder(
          borderRadius: .circular(16),
        ),

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            mainAxisAlignment:.center ,
            crossAxisAlignment: .start,
            children: [
              Row(

                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isIncome
                          ? Icons.arrow_downward_rounded
                          : Icons.arrow_upward_rounded,

                      size: 18,

                      color: isIncome
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                    ),
                  ),
                  const SizedBox(width: 8,),

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Text(
                '₹${amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}