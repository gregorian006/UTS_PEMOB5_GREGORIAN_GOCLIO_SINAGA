class ScoreRecord {
  const ScoreRecord({
    required this.playerName,
    required this.categoryTitle,
    required this.correct,
    required this.unanswered,
    required this.total,
    required this.finishedAt,
    required this.weakTopics,
  });

  final String playerName;
  final String categoryTitle;
  final int correct;
  final int unanswered;
  final int total;
  final DateTime finishedAt;

  /// Topik dari soal yang salah atau kosong, tanpa duplikat.
  final List<String> weakTopics;

  int get wrong => total - correct - unanswered;
  int get percentage => (correct * 100 / total).round();
}
