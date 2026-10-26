import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../utils/responsive.dart';
import '../widgets/empty_state.dart';
import '../widgets/option_tile.dart';
import '../widgets/responsive_center.dart';
import '../widgets/theme_toggle_button.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  static const routeName = '/review';

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    if (!quiz.isFinished) return const EmptyState();

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembahasan'),
        actions: const [ThemeToggleButton()],
      ),
      body: ResponsiveCenter(
        maxWidthFactor: 1.3,
        child: Column(
          children: [
            for (var q = 0; q < quiz.totalQuestions; q++)
              Card(
                margin: EdgeInsets.only(bottom: context.rs(0.04)),
                child: Padding(
                  padding: EdgeInsets.all(context.rs(0.045)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Soal ${q + 1}',
                          style: theme.textTheme.labelLarge?.copyWith(color: scheme.primary)),
                      SizedBox(height: context.rs(0.01)),
                      Text(quiz.questions[q].text,
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      SizedBox(height: context.rs(0.03)),
                      for (var i = 0; i < quiz.questions[q].options.length; i++)
                        OptionTile(
                          label: optionLabels[i],
                          text: quiz.questions[q].options[i],
                          state: i == quiz.questions[q].answerIndex
                              ? OptionState.correct
                              : i == quiz.answers[q]
                                  ? OptionState.wrong
                                  : OptionState.idle,
                        ),
                      if (quiz.answers[q] == null)
                        Padding(
                          padding: EdgeInsets.only(bottom: context.rs(0.02)),
                          child: Text('Tidak dijawab',
                              style: theme.textTheme.labelLarge?.copyWith(color: scheme.error)),
                        ),
                      Container(
                        padding: EdgeInsets.all(context.rs(0.035)),
                        decoration: BoxDecoration(
                          color: scheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(context.rs(0.03)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.lightbulb_rounded, color: scheme.onTertiaryContainer),
                            SizedBox(width: context.rs(0.025)),
                            Expanded(
                              child: Text(
                                quiz.questions[q].explanation,
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(color: scheme.onTertiaryContainer),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
