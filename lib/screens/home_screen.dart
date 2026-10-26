import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../data/quiz_data.dart';
import '../models/question.dart';
import '../providers/quiz_provider.dart';
import '../utils/responsive.dart';
import '../widgets/category_card.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/responsive_center.dart';
import '../widgets/theme_toggle_button.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: context.read<QuizProvider>().playerName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _startQuiz(QuizCategory category) async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final quiz = context.read<QuizProvider>();
    if (quiz.hasActiveQuiz) {
      final confirmed = await showConfirmDialog(
        context,
        title: 'Mulai kuis baru?',
        message: 'Progres kuis ${quiz.category!.title} yang belum selesai akan hilang.',
        confirmLabel: 'Mulai Baru',
      );
      if (!confirmed || !mounted) return;
    }

    quiz.startQuiz(_nameController.text, category);
    Navigator.pushNamed(context, QuizScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    final gap = SizedBox(height: context.rs(0.05), width: context.rs(0.05));

    final left = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Header(),
        gap,
        _NameForm(formKey: _formKey, controller: _nameController),
        if (quiz.hasActiveQuiz) ...[gap, const _ResumeCard()],
      ],
    );

    final right = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle(icon: Icons.category_rounded, title: 'Pilih Kategori'),
        for (final category in quizCategories)
          CategoryCard(category: category, onTap: () => _startQuiz(category)),
        if (quiz.leaderboard.isNotEmpty) ...[
          SizedBox(height: context.rs(0.03)),
          const _SectionTitle(icon: Icons.leaderboard_rounded, title: 'Papan Skor'),
          const _Leaderboard(),
        ],
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kuis Nusantara'),
        actions: const [ThemeToggleButton()],
      ),
      body: ResponsiveCenter(
        child: context.isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Expanded(child: left), gap, Expanded(child: right)],
              )
            : Column(children: [left, gap, right]),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        SvgPicture.asset('assets/images/logo.svg', height: context.rs(0.4)),
        SizedBox(height: context.rs(0.03)),
        Text(
          'Uji Wawasan Nusantaramu!',
          textAlign: TextAlign.center,
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: context.rs(0.015)),
        Text(
          'Jawab soal seputar sejarah, geografi, dan budaya Indonesia, lalu lihat skormu.',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _NameForm extends StatelessWidget {
  const _NameForm({required this.formKey, required this.controller});

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: TextFormField(
        controller: controller,
        maxLength: 25,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          labelText: 'Nama kamu',
          hintText: 'Masukkan nama sebelum memilih kategori',
          prefixIcon: Icon(Icons.person_rounded),
        ),
        validator: (value) =>
            (value == null || value.trim().isEmpty) ? 'Nama wajib diisi dulu, ya' : null,
      ),
    );
  }
}

class _ResumeCard extends StatelessWidget {
  const _ResumeCard();

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    final scheme = Theme.of(context).colorScheme;

    return Card(
      color: scheme.primaryContainer,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.rs(0.04),
          vertical: context.rs(0.015),
        ),
        leading: Icon(Icons.play_circle_fill_rounded, color: scheme.primary, size: context.rs(0.1)),
        title: Text('Lanjutkan ${quiz.category!.title}'),
        subtitle: Text('${quiz.playerName} • ${quiz.answeredCount}/${quiz.totalQuestions} terjawab'),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => Navigator.pushNamed(context, QuizScreen.routeName),
      ),
    );
  }
}

class _Leaderboard extends StatelessWidget {
  const _Leaderboard();

  @override
  Widget build(BuildContext context) {
    final top = context.watch<QuizProvider>().leaderboard.take(5).toList();
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: Column(
        children: [
          for (var i = 0; i < top.length; i++)
            ListTile(
              leading: CircleAvatar(
                backgroundColor: i == 0 ? Colors.amber : scheme.secondaryContainer,
                foregroundColor: i == 0 ? Colors.black : scheme.onSecondaryContainer,
                child: Text('${i + 1}'),
              ),
              title: Text(top[i].playerName, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(top[i].categoryTitle),
              trailing: Text(
                '${top[i].correct}/${top[i].total}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: scheme.primary,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.rs(0.03)),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          SizedBox(width: context.rs(0.02)),
          Text(title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
