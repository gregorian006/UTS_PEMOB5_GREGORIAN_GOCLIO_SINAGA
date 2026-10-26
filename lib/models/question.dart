import 'package:flutter/material.dart';

class Question {
  const Question({
    required this.text,
    required this.options,
    required this.answerIndex,
    required this.topic,
    required this.explanation,
  });

  final String text;
  final List<String> options;
  final int answerIndex;

  /// Topik materi, dipakai untuk saran belajar bila soal dijawab salah.
  final String topic;
  final String explanation;
}

class QuizCategory {
  const QuizCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.color,
    required this.questions,
  });

  final String id;
  final String title;
  final String description;
  final String imageAsset;
  final Color color;
  final List<Question> questions;
}
