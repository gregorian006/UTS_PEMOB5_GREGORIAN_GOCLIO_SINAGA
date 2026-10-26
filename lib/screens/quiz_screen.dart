import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../utils/responsive.dart';
import '../widgets/app_button.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/empty_state.dart';
import '../widgets/option_tile.dart';
import '../widgets/quiz_progress_bar.dart';
import '../widgets/responsive_center.dart';
import '../widgets/theme_toggle_button.dart';
import '../widgets/timer_badge.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  static const routeName = '/quiz';

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final QuizProvider _quiz;
  bool _leaving = false;

  @override
  void initState() {
    super.initState();
    // Timer hanya berjalan selama halaman kuis tampil.
    _quiz = context.read<QuizProvider>();
    _quiz.resumeTimer();
  }

  @override
  void dispose() {
    _quiz.pauseTimer();
    super.dispose();
  }

  void _goToResult() {
    _leaving = true;
    _quiz.finish();
    Navigator.pushReplacementNamed(context, ResultScreen.routeName);
  }

  Future<void> _finish() async {
    final unanswered = _quiz.totalQuestions - _quiz.answeredCount;
    if (unanswered > 0) {
      final confirmed = await showConfirmDialog(
        context,
        title: 'Selesaikan kuis?',
        message: 'Masih ada $unanswered soal yang belum dijawab. Soal kosong dihitung salah.',
        confirmLabel: 'Selesai',
      );
      if (!confirmed || !mounted || _leaving) return;
    }
    _goToResult();
  }

  /// Semua soal kehabisan waktu: tutup dialog yang mungkin terbuka, lalu ke hasil.
  void _autoFinish() {
    if (!mounted || _leaving) return;
    final route = ModalRoute.of(context);
    Navigator.popUntil(context, (r) => r == route);
    _goToResult();
  }

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    if (quiz.questions.isEmpty) return const EmptyState();
    if (quiz.allTimeUp && !_leaving) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _autoFinish());
    }

    final question = quiz.currentQuestion;
    final timeUp = quiz.isTimeUp(quiz.currentIndex);
    final scheme = Theme.of(context).colorScheme;
    final gap = SizedBox(height: context.rs(0.04), width: context.rs(0.04));

    final questionCard = Card(
      child: Padding(
        padding: EdgeInsets.all(context.rs(0.05)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Chip(
                      avatar: const Icon(Icons.help_outline_rounded),
                      label: Text('Pertanyaan ${quiz.currentIndex + 1}'),
                    ),
                  ),
                ),
                TimerBadge(secondsLeft: quiz.timeLeft, totalSeconds: secondsPerQuestion),
              ],
            ),
            SizedBox(height: context.rs(0.03)),
            Text(
              question.text,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (timeUp) ...[
              SizedBox(height: context.rs(0.03)),
              Row(
                children: [
                  Icon(Icons.lock_clock_rounded, color: scheme.error),
                  SizedBox(width: context.rs(0.02)),
                  Expanded(
                    child: Text(
                      'Waktu soal ini habis, jawaban dikunci.',
                      style: TextStyle(color: scheme.error),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );

    final options = Column(
      children: [
        for (var i = 0; i < question.options.length; i++)
          OptionTile(
            label: optionLabels[i],
            text: question.options[i],
            state: quiz.currentAnswer == i ? OptionState.selected : OptionState.idle,
            onTap: timeUp ? null : () => quiz.selectAnswer(i),
          ),
      ],
    );

    final navigation = Row(
      children: [
        Expanded(
          child: AppButton(
            label: 'Sebelumnya',
            icon: Icons.arrow_back_rounded,
            outlined: true,
            onPressed: quiz.isFirst ? null : quiz.previous,
          ),
        ),
        gap,
        Expanded(
          child: quiz.isLast
              ? AppButton(label: 'Selesai', icon: Icons.flag_rounded, onPressed: _finish)
              : AppButton(
                  label: 'Berikutnya',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: quiz.next,
                ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(quiz.category!.title),
        actions: const [ThemeToggleButton()],
      ),
      body: ResponsiveCenter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            QuizProgressBar(
              current: quiz.currentIndex + 1,
              total: quiz.totalQuestions,
              answered: quiz.answeredCount,
            ),
            gap,
            if (context.isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: questionCard),
                  gap,
                  Expanded(flex: 6, child: options),
                ],
              )
            else ...[
              questionCard,
              gap,
              options,
            ],
            gap,
            const _QuestionNavigator(),
            gap,
            navigation,
          ],
        ),
      ),
    );
  }
}

/// Nomor-nomor soal untuk melompat langsung; yang sudah dijawab atau
/// kehabisan waktu ditandai ikon.
class _QuestionNavigator extends StatelessWidget {
  const _QuestionNavigator();

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    final scheme = Theme.of(context).colorScheme;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: context.rs(0.02),
      runSpacing: context.rs(0.02),
      children: [
        for (var i = 0; i < quiz.totalQuestions; i++)
          ChoiceChip(
            label: Text('${i + 1}'),
            selected: quiz.currentIndex == i,
            avatar: quiz.answers[i] != null
                ? Icon(Icons.check_rounded, color: scheme.primary)
                : quiz.isTimeUp(i)
                    ? Icon(Icons.timer_off_rounded, color: scheme.error)
                    : null,
            showCheckmark: false,
            onSelected: (_) => quiz.goTo(i),
          ),
      ],
    );
  }
}
