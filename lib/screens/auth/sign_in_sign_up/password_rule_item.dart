import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class PasswordRuleItem extends StatelessWidget {
  final bool isValid;
  final String text;

  const PasswordRuleItem(
      {super.key, required this.isValid, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          size: 16,
          color: isValid ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: primaryTextStyle(size: 12)),
        ),
      ],
    );
  }
}
