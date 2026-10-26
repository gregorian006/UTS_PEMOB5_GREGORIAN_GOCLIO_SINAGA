import 'package:flutter/material.dart';

import '../utils/responsive.dart';

const optionLabels = ['A', 'B', 'C', 'D'];

enum OptionState { idle, selected, correct, wrong }

/// Satu pilihan jawaban. Dipakai di halaman kuis dan halaman pembahasan.
class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.label,
    required this.text,
    this.state = OptionState.idle,
    this.onTap,
  });

  final String label;
  final String text;
  final OptionState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final success = theme.brightness == Brightness.dark ? Colors.green.shade300 : Colors.green.shade700;

    final accent = switch (state) {
      OptionState.idle => scheme.outlineVariant,
      OptionState.selected => scheme.primary,
      OptionState.correct => success,
      OptionState.wrong => scheme.error,
    };
    final trailingIcon = switch (state) {
      OptionState.idle => null,
      OptionState.selected => Icons.radio_button_checked_rounded,
      OptionState.correct => Icons.check_circle_rounded,
      OptionState.wrong => Icons.cancel_rounded,
    };
    final highlighted = state != OptionState.idle;
    final onAccent =
        ThemeData.estimateBrightnessForColor(accent) == Brightness.dark ? Colors.white : Colors.black;
    final badgeSize = context.rs(0.09);

    return Padding(
      padding: EdgeInsets.only(bottom: context.rs(0.025)),
      child: Material(
        color: highlighted ? accent.withValues(alpha: 0.12) : scheme.surfaceContainerLow,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.rs(0.04)),
          side: BorderSide(color: accent, width: highlighted ? 2 : 1),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(context.rs(0.035)),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: badgeSize,
                  height: badgeSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: highlighted ? accent : scheme.surfaceContainerHighest,
                  ),
                  child: Text(
                    label,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: highlighted ? onAccent : scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                SizedBox(width: context.rs(0.035)),
                Expanded(child: Text(text, style: theme.textTheme.bodyLarge)),
                if (trailingIcon != null) ...[
                  SizedBox(width: context.rs(0.02)),
                  Icon(trailingIcon, color: accent),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
