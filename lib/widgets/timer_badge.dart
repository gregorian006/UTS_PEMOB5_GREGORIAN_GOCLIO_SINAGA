import 'package:flutter/material.dart';

import '../utils/responsive.dart';

/// Hitung mundur berbentuk lingkaran; berubah merah saat waktu hampir habis.
class TimerBadge extends StatelessWidget {
  const TimerBadge({super.key, required this.secondsLeft, required this.totalSeconds});

  final int secondsLeft;
  final int totalSeconds;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = secondsLeft <= 5 ? scheme.error : scheme.primary;
    final size = context.rs(0.13);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(end: secondsLeft / totalSeconds),
            duration: const Duration(seconds: 1),
            builder: (context, value, _) => CircularProgressIndicator(
              value: value,
              strokeWidth: context.rs(0.012),
              color: color,
              backgroundColor: color.withValues(alpha: 0.15),
            ),
          ),
          Center(
            child: secondsLeft == 0
                ? Icon(Icons.timer_off_rounded, color: color)
                : Text(
                    '$secondsLeft',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold, color: color),
                  ),
          ),
        ],
      ),
    );
  }
}
