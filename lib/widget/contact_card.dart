import 'package:flutter/material.dart';
import 'package:folio/configs/configs.dart';
import 'package:folio/constants.dart';
import 'package:folio/provider/app_provider.dart';
import 'package:provider/provider.dart';

/// Tile in the "Get in Touch" row: location, phone, email.
///
/// Shares the visual language of [ProjectCard] - rounded surface, hairline
/// border, lift and accent glow on hover.
class ContactCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String detail;
  final String? link;

  const ContactCard({
    super.key,
    required this.icon,
    required this.title,
    required this.detail,
    this.link,
  });

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDark;
    final accent = AppTheme.c!.primary!;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final surface = isDark ? const Color(0xff141416) : Colors.white;

    return MouseRegion(
      cursor: widget.link == null
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () {
          if (widget.link != null) openURL(widget.link!);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _hover ? -6 : 0, 0),
          width: AppDimensions.normalize(115),
          height: AppDimensions.normalize(72),
          margin: EdgeInsets.symmetric(horizontal: AppDimensions.normalize(5)),
          padding: EdgeInsets.all(AppDimensions.normalize(8)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.normalize(8)),
            border: Border.all(
              color: _hover
                  ? accent.withValues(alpha: 0.65)
                  : (isDark ? Colors.white12 : Colors.black12),
              width: 1.4,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.alphaBlend(accent.withValues(alpha: 0.08), surface),
                surface,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: _hover
                    ? accent.withValues(alpha: 0.30)
                    : Colors.black.withValues(alpha: isDark ? 0.45 : 0.10),
                blurRadius: _hover ? 24 : 14,
                offset: Offset(0, _hover ? 10 : 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(AppDimensions.normalize(5)),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: 0.14),
                  border: Border.all(color: accent.withValues(alpha: 0.35)),
                ),
                child: Icon(
                  widget.icon,
                  color: accent,
                  size: AppDimensions.normalize(13),
                ),
              ),
              SizedBox(height: AppDimensions.normalize(4)),
              Text(
                widget.title,
                style: AppText.b2b!.copyWith(fontFamily: 'Montserrat'),
              ),
              SizedBox(height: AppDimensions.normalize(1.5)),
              Text(
                widget.detail,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppText.l1!.copyWith(
                  color: onSurface.withValues(alpha: 0.72),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
