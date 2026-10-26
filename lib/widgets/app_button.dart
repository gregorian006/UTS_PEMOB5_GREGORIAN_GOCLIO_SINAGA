import 'package:flutter/material.dart';

import '../utils/responsive.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
    this.outlined = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final style = ButtonStyle(
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(vertical: context.rs(0.04), horizontal: context.rs(0.04)),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.rs(0.04))),
      ),
    );
    final text = Text(label, maxLines: 1, overflow: TextOverflow.ellipsis);

    return SizedBox(
      width: double.infinity,
      child: outlined
          ? OutlinedButton.icon(onPressed: onPressed, style: style, icon: Icon(icon), label: text)
          : FilledButton.icon(onPressed: onPressed, style: style, icon: Icon(icon), label: text),
    );
  }
}
