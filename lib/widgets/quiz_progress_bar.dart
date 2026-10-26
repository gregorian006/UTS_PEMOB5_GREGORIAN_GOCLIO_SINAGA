import 'package:flutter/material.dart';

import '../utils/responsive.dart';

class QuizProgressBar extends StatelessWidget {
  const QuizProgressBar({
    super.key,
    required this.current,
    required this.total,
    required this.answered,
  });

  final int current;
  final int total;
  final int answered;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Soal $current dari $total',
                style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            Text('$answered/$total terjawab', style: textTheme.bodySmall),
          ],
        ),
        SizedBox(height: context.rs(0.02)),
        ClipRRect(
          borderRadius: BorderRadius.circular(context.rs(0.02)),
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: answered / total),
            duration: const Duration(milliseconds: 300),
            builder: (context, value, _) =>
                LinearProgressIndicator(value: value, minHeight: context.rs(0.022)),
          ),
        ),
      ],
    );
  }
}
