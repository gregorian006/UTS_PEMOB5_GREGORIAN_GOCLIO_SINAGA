import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../utils/responsive.dart';
import '../widgets/app_button.dart';
import '../widgets/empty_state.dart';
import '../widgets/responsive_center.dart';
import '../widgets/stat_tile.dart';
import '../widgets/theme_toggle_button.dart';
import 'home_screen.dart';
import 'quiz_screen.dart';
import 'review_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  static const routeName = '/result';

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final _confetti = ConfettiController(duration: const Duration(seconds: 3));

  @override
  void initState() {
    super.initState();
    // Rayakan skor sempurna. Dimainkan sekali saja, tidak terulang saat rotasi.
    final result = context.read<QuizProvider>().lastResult;
    if (result != null && result.correct == result.total) _confetti.play();
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Hasil diambil dari riwayat, jadi tidak ikut berubah saat "Main Lagi" ditekan.
    final result = context.select((QuizProvider q) => q.lastResult);
    if (result == null) return const EmptyState();

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final ratio = result.correct / result.total;
    final (headline, message) = switch (ratio) {
      >= 0.8 => ('Luar biasa', 'Wawasan Nusantaramu sangat mantap!'),
      >= 0.6 => ('Kerja bagus', 'Sedikit lagi menuju sempurna.'),
      >= 0.4 => ('Lumayan', 'Ayo baca pembahasan dan coba lagi.'),
      _ => ('Jangan menyerah', 'Setiap percobaan menambah pengetahuan.'),
    };
    final gap = SizedBox(height: context.rs(0.04), width: context.rs(0.03));
    final circleSize = context.rs(0.42);

    final summary = Column(
      children: [
        SvgPicture.asset('assets/images/trophy.svg', height: context.rs(0.35)),
        gap,
        Text(
          '$headline, ${result.playerName}!',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(message, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
        SizedBox(height: context.rs(0.01)),
        Text(result.categoryTitle,
            style: theme.textTheme.labelLarge?.copyWith(color: scheme.primary)),
      ],
    );

    final score = Column(
      children: [
        SizedBox(
          width: circleSize,
          height: circleSize,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: ratio),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: value,
                  strokeWidth: context.rs(0.03),
                  strokeCap: StrokeCap.round,
                  backgroundColor: scheme.surfaceContainerHighest,
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(value * 100).round()}',
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: scheme.primary,
                        ),
                      ),
                      Text('Skor', style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        gap,
        Row(
          children: [
            Expanded(
              child: StatTile(
                icon: Icons.check_circle_rounded,
                label: 'Benar',
                value: '${result.correct}',
                color: theme.brightness == Brightness.dark
                    ? Colors.green.shade300
                    : Colors.green.shade700,
              ),
            ),
            gap,
            Expanded(
              child: StatTile(
                icon: Icons.cancel_rounded,
                label: 'Salah',
                value: '${result.wrong}',
                color: scheme.error,
              ),
            ),
            gap,
            Expanded(
              child: StatTile(
                icon: Icons.remove_circle_rounded,
                label: 'Kosong',
                value: '${result.unanswered}',
                color: scheme.outline,
              ),
            ),
          ],
        ),
        gap,
        _StudySuggestion(topics: result.weakTopics),
        gap,
        AppButton(
          label: 'Lihat Pembahasan',
          icon: Icons.menu_book_rounded,
          onPressed: () => Navigator.pushNamed(context, ReviewScreen.routeName),
        ),
        SizedBox(height: context.rs(0.03)),
        AppButton(
          label: 'Main Lagi',
          icon: Icons.replay_rounded,
          outlined: true,
          onPressed: () {
            context.read<QuizProvider>().restart();
            Navigator.pushReplacementNamed(context, QuizScreen.routeName);
          },
        ),
        SizedBox(height: context.rs(0.03)),
        AppButton(
          label: 'Kembali ke Beranda',
          icon: Icons.home_rounded,
          outlined: true,
          onPressed: () =>
              Navigator.popUntil(context, ModalRoute.withName(HomeScreen.routeName)),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Kuis'),
        automaticallyImplyLeading: false,
        actions: const [ThemeToggleButton()],
      ),
      body: Stack(
        children: [
          ResponsiveCenter(
            maxWidthFactor: 1.6,
            child: context.isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [Expanded(child: summary), gap, Expanded(child: score)],
                  )
                : Column(children: [summary, gap, score]),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 30,
              colors: [scheme.primary, scheme.tertiary, Colors.amber, Colors.redAccent],
            ),
          ),
        ],
      ),
    );
  }
}

/// Saran topik yang perlu dipelajari lagi berdasarkan soal yang salah/kosong.
class _StudySuggestion extends StatelessWidget {
  const _StudySuggestion({required this.topics});

  final List<String> topics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final perfect = topics.isEmpty;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.rs(0.045)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(perfect ? Icons.emoji_events_rounded : Icons.school_rounded,
                    color: scheme.primary),
                SizedBox(width: context.rs(0.02)),
                Expanded(
                  child: Text(
                    perfect ? 'Semua jawaban benar!' : 'Saran Belajar',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.rs(0.02)),
            Text(
              perfect
                  ? 'Hebat! Coba kategori lain untuk menguji wawasanmu yang lain.'
                  : 'Pelajari lagi topik berikut agar skormu naik di percobaan berikutnya:',
              style: theme.textTheme.bodyMedium,
            ),
            if (!perfect) ...[
              SizedBox(height: context.rs(0.02)),
              for (final topic in topics)
                Padding(
                  padding: EdgeInsets.only(bottom: context.rs(0.015)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.arrow_right_rounded, color: scheme.primary),
                      Expanded(
                        child: Text(topic,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
              Text(
                'Tip: buka Pembahasan untuk membaca penjelasan tiap soal.',
                style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
