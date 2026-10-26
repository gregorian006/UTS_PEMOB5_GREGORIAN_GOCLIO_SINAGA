import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/question.dart';
import '../providers/quiz_provider.dart';
import '../utils/responsive.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category, required this.onTap});

  final QuizCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final imageSize = context.rs(0.18);

    return Card(
      margin: EdgeInsets.only(bottom: context.rs(0.03)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(context.rs(0.035)),
          child: Row(
            children: [
              Container(
                width: imageSize,
                height: imageSize,
                padding: EdgeInsets.all(context.rs(0.02)),
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(context.rs(0.04)),
                ),
                child: SvgPicture.asset(category.imageAsset),
              ),
              SizedBox(width: context.rs(0.04)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category.title,
                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    Text(
                      category.description,
                      style: textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.rs(0.015)),
                    Row(
                      children: [
                        Icon(Icons.quiz_outlined, size: context.rs(0.045), color: category.color),
                        SizedBox(width: context.rs(0.01)),
                        Text(
                          '$questionsPerQuiz soal acak dari ${category.questions.length}',
                          style: textTheme.labelMedium?.copyWith(color: category.color),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
