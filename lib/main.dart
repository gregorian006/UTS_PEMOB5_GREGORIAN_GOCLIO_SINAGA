import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/quiz_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/result_screen.dart';
import 'screens/review_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    // Provider diletakkan di atas MaterialApp agar state kuis tetap hidup
    // saat layar dirotasi maupun saat berpindah halaman.
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const KuisNusantaraApp(),
    ),
  );
}

class KuisNusantaraApp extends StatelessWidget {
  const KuisNusantaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>().themeMode;

    return MaterialApp(
      title: 'Kuis Nusantara',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (_) => const HomeScreen(),
        QuizScreen.routeName: (_) => const QuizScreen(),
        ResultScreen.routeName: (_) => const ResultScreen(),
        ReviewScreen.routeName: (_) => const ReviewScreen(),
      },
    );
  }
}
