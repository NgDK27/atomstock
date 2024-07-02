
import 'package:flutter/cupertino.dart';

enum AiSelectCardType { recommended, comingSoon }

class AiSelectCardModel {
  final Color themeColor;
  final String aiName;
  final AiSelectCardType type;
  final String summary;
  final String description;
  final Widget illustration;
  final int accuracyPercentage;
  final String supportingText;

  AiSelectCardModel({
    required this.themeColor,
    required this.aiName,
    required this.type,
    required this.summary,
    required this.description,
    required this.illustration,
    required this.accuracyPercentage,
    required this.supportingText,
  });
}