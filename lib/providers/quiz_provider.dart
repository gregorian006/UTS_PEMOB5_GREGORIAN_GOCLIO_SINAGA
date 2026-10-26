import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/question.dart';
import '../models/score_record.dart';

/// Jumlah soal per sesi, diambil acak dari bank soal kategori.
const questionsPerQuiz = 5;

/// Batas waktu tiap soal (detik).
const secondsPerQuestion = 20;

/// Menyimpan seluruh state kuis: nama pemain, soal, jawaban, dan riwayat skor.
class QuizProvider extends ChangeNotifier {
  final _random = Random();

  String _playerName = '';
  QuizCategory? _category;
  List<Question> _questions = [];
  List<int?> _answers = [];
  int _currentIndex = 0;
  bool _finished = false;
  final List<ScoreRecord> _history = [];

  // Sisa waktu disimpan per soal agar tidak ter-reset saat rotasi/pindah halaman.
  List<int> _timeLeft = [];
  Timer? _timer;

  String get playerName => _playerName;
  QuizCategory? get category => _category;
  List<Question> get questions => List.unmodifiable(_questions);
  List<int?> get answers => List.unmodifiable(_answers);
  int get currentIndex => _currentIndex;
  int get totalQuestions => _questions.length;
  Question get currentQuestion => _questions[_currentIndex];
  int? get currentAnswer => _answers[_currentIndex];
  bool get isFirst => _currentIndex == 0;
  bool get isLast => _currentIndex == _questions.length - 1;
  bool get isFinished => _finished;
  int get timeLeft => _timeLeft[_currentIndex];
  bool isTimeUp(int index) => _timeLeft[index] == 0;
  bool get allTimeUp => _timeLeft.isNotEmpty && _timeLeft.every((t) => t == 0);

  /// Ada kuis yang sudah dimulai tapi belum diselesaikan.
  bool get hasActiveQuiz => _questions.isNotEmpty && !_finished;

  int get answeredCount => _answers.where((a) => a != null).length;

  int get score {
    var correct = 0;
    for (var i = 0; i < _questions.length; i++) {
      if (_answers[i] == _questions[i].answerIndex) correct++;
    }
    return correct;
  }

  ScoreRecord? get lastResult => _history.isEmpty ? null : _history.last;

  /// Riwayat skor diurutkan dari persentase tertinggi.
  List<ScoreRecord> get leaderboard => [..._history]
    ..sort((a, b) {
      final byScore = b.percentage.compareTo(a.percentage);
      return byScore != 0 ? byScore : a.finishedAt.compareTo(b.finishedAt);
    });

  void startQuiz(String name, QuizCategory category, {bool shuffle = true}) {
    _playerName = name.trim();
    _category = category;
    final bank = [...category.questions];
    if (shuffle) bank.shuffle(_random);
    _questions = bank.take(questionsPerQuiz).toList();
    _answers = List<int?>.filled(_questions.length, null);
    _timeLeft = List<int>.filled(_questions.length, secondsPerQuestion);
    _currentIndex = 0;
    _finished = false;
    notifyListeners();
  }

  void restart() => startQuiz(_playerName, _category!);

  void selectAnswer(int optionIndex) {
    if (_finished || isTimeUp(_currentIndex)) return;
    _answers[_currentIndex] = optionIndex;
    notifyListeners();
  }

  void goTo(int index) {
    if (index < 0 || index >= _questions.length) return;
    _currentIndex = index;
    notifyListeners();
  }

  void next() => goTo(_currentIndex + 1);

  void previous() => goTo(_currentIndex - 1);

  /// Dipanggil saat halaman kuis tampil. Tidak memanggil notifyListeners
  /// karena dijalankan dari initState.
  void resumeTimer() {
    if (!hasActiveQuiz) return;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  /// Dipanggil saat halaman kuis ditutup, sehingga waktu berhenti di beranda.
  void pauseTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// Kurangi sisa waktu soal aktif. Jika habis, soal dikunci dan pindah
  /// otomatis ke soal berikutnya yang masih punya waktu.
  @visibleForTesting
  void tick() {
    if (!hasActiveQuiz) return pauseTimer();
    if (isTimeUp(_currentIndex)) return;
    _timeLeft[_currentIndex]--;
    if (isTimeUp(_currentIndex)) {
      for (var step = 1; step < _questions.length; step++) {
        final i = (_currentIndex + step) % _questions.length;
        if (!isTimeUp(i)) {
          _currentIndex = i;
          break;
        }
      }
    }
    notifyListeners();
  }

  void finish() {
    if (_finished || _questions.isEmpty) return;
    _finished = true;
    pauseTimer();
    _history.add(ScoreRecord(
      playerName: _playerName,
      categoryTitle: _category!.title,
      correct: score,
      unanswered: _questions.length - answeredCount,
      total: _questions.length,
      finishedAt: DateTime.now(),
      weakTopics: {
        for (var i = 0; i < _questions.length; i++)
          if (_answers[i] != _questions[i].answerIndex) _questions[i].topic,
      }.toList(),
    ));
    notifyListeners();
  }

  @override
  void dispose() {
    pauseTimer();
    super.dispose();
  }
}
