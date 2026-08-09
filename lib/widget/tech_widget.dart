import 'package:flutter/material.dart';
import 'package:folio/configs/app_dimensions.dart';
import 'package:folio/configs/app_theme.dart';
import 'package:folio/configs/app_typography.dart';

/// Pill-shaped tag used for the "technologies I have worked with" list.
class ToolTechWidget extends StatelessWidget {
  final String techName;

  const ToolTechWidget({Key? key, required this.techName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primary = AppTheme.c!.primary!;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.normalize(5),
        vertical: AppDimensions.normalize(2.5),
      ),
      decoration: BoxDecoration(
        color: primary.withAlpha(20),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: primary.withAlpha(90)),
      ),
      child: Text(
        techName,
        style: AppText.l1b!.copyWith(color: primary),
      ),
    );
  }
}
