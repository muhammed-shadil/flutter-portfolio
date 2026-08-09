import 'package:flutter/material.dart';
import 'package:folio/configs/configs.dart';
import 'package:folio/constants.dart';
import 'package:folio/provider/app_provider.dart';
import 'package:folio/utils/project_utils.dart';
import 'package:provider/provider.dart';

/// Card for a single app in the portfolio grid.
///
/// Shows the launcher icon against a halo of the app's own brand colour, the
/// title and tagline, a short blurb, the stack it was built with, and a link
/// out to the store listing (or the source, for the unpublished ones).
class ProjectCard extends StatefulWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hover = false;

  void _open() {
    final link = widget.project.link;
    if (link != null) openURL(link);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AppProvider>(context).isDark;
    final project = widget.project;
    final accent = project.accent;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    final surface = isDark ? const Color(0xff141416) : Colors.white;
    final borderColor = _hover
        ? accent.withValues(alpha: 0.65)
        : (isDark ? Colors.white12 : Colors.black12);

    return MouseRegion(
      cursor: project.link == null
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: _open,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _hover ? -8 : 0, 0),
          width: AppDimensions.normalize(115),
          height: AppDimensions.normalize(125),
          padding: EdgeInsets.all(AppDimensions.normalize(9)),
          margin: EdgeInsets.symmetric(horizontal: AppDimensions.normalize(5)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.normalize(8)),
            border: Border.all(color: borderColor, width: 1.4),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.alphaBlend(accent.withValues(alpha: 0.10), surface),
                surface,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: _hover
                    ? accent.withValues(alpha: 0.32)
                    : Colors.black.withValues(alpha: isDark ? 0.45 : 0.10),
                blurRadius: _hover ? 26 : 14,
                offset: Offset(0, _hover ? 12 : 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(project: project, accent: accent),
              SizedBox(height: AppDimensions.normalize(5)),
              Expanded(
                child: Text(
                  project.description,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.l1!.copyWith(
                    height: 1.7,
                    color: onSurface.withValues(alpha: 0.72),
                  ),
                ),
              ),
              SizedBox(height: AppDimensions.normalize(3)),
              _TechRow(project: project, accent: accent, onSurface: onSurface),
              SizedBox(height: AppDimensions.normalize(4)),
              _LinkPill(project: project, accent: accent, hover: _hover),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Project project;
  final Color accent;

  const _Header({required this.project, required this.accent});

  @override
  Widget build(BuildContext context) {
    final box = AppDimensions.normalize(26);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: box,
          width: box,
          padding: EdgeInsets.all(AppDimensions.normalize(2)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.normalize(6)),
            color: accent.withValues(alpha: 0.14),
            border: Border.all(color: accent.withValues(alpha: 0.35)),
          ),
          child: project.icon != null
              ? ClipRRect(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.normalize(4)),
                  child: Image.asset(project.icon!, fit: BoxFit.contain),
                )
              : Icon(
                  project.iconData,
                  color: accent,
                  size: AppDimensions.normalize(14),
                ),
        ),
        SizedBox(width: AppDimensions.normalize(5)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.b2b!.copyWith(fontFamily: 'Montserrat'),
              ),
              SizedBox(height: AppDimensions.normalize(1)),
              Text(
                project.tagline,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppText.l1!.copyWith(color: accent),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TechRow extends StatelessWidget {
  final Project project;
  final Color accent;
  final Color onSurface;

  const _TechRow({
    required this.project,
    required this.accent,
    required this.onSurface,
  });

  @override
  Widget build(BuildContext context) {
    // Keep every card the same height: show three tags, then a "+n" counter.
    const shown = 3;
    final extra = project.tech.length - shown;
    final tags = project.tech.take(shown).toList();
    if (extra > 0) tags.add('+$extra');

    return Wrap(
      spacing: AppDimensions.normalize(2.5),
      runSpacing: AppDimensions.normalize(2.5),
      children: tags
          .map(
            (t) => Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.normalize(3.5),
                vertical: AppDimensions.normalize(1.5),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: onSurface.withValues(alpha: 0.06),
                border: Border.all(color: onSurface.withValues(alpha: 0.14)),
              ),
              child: Text(
                t,
                style: AppText.l2b!.copyWith(
                  color: onSurface.withValues(alpha: 0.75),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _LinkPill extends StatelessWidget {
  final Project project;
  final Color accent;
  final bool hover;

  const _LinkPill({
    required this.project,
    required this.accent,
    required this.hover,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    if (project.linkKind == ProjectLinkKind.none) {
      return Row(
        children: [
          Icon(
            Icons.business_center_rounded,
            size: AppDimensions.normalize(7),
            color: onSurface.withValues(alpha: 0.45),
          ),
          SizedBox(width: AppDimensions.normalize(2)),
          Text(
            'Company project',
            style: AppText.l2b!.copyWith(
              color: onSurface.withValues(alpha: 0.45),
            ),
          ),
        ],
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.normalize(5),
        vertical: AppDimensions.normalize(2.5),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: hover ? accent : accent.withValues(alpha: 0.14),
        border: Border.all(color: accent.withValues(alpha: 0.55)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            project.linkIcon,
            size: AppDimensions.normalize(7),
            color: hover ? Colors.white : accent,
          ),
          SizedBox(width: AppDimensions.normalize(2)),
          Text(
            project.linkLabel,
            style: AppText.l2b!.copyWith(
              color: hover ? Colors.white : accent,
            ),
          ),
          SizedBox(width: AppDimensions.normalize(1)),
          Icon(
            Icons.arrow_outward_rounded,
            size: AppDimensions.normalize(6),
            color: hover ? Colors.white : accent,
          ),
        ],
      ),
    );
  }
}
