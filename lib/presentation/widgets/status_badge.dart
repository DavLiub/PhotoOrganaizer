import 'package:flutter/material.dart';

import '../theme/app_status_palette.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    required this.label,
    required this.tone,
    this.icon,
    this.semanticLabel,
    super.key,
  });

  final String label;
  final AppStatusTone tone;
  final IconData? icon;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final style = context.statusPalette.resolve(tone);
    final badgeIcon = icon ?? _toneIcon(tone);

    return Semantics(
      label: semanticLabel ?? label,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: style.background,
          border: Border.all(color: style.border),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(badgeIcon, size: 13, color: style.foreground),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: style.foreground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _toneIcon(AppStatusTone tone) {
    return switch (tone) {
      AppStatusTone.protected => Icons.verified_outlined,
      AppStatusTone.queued => Icons.schedule_outlined,
      AppStatusTone.inProgress => Icons.sync_outlined,
      AppStatusTone.failed => Icons.error_outline,
      AppStatusTone.ignored => Icons.visibility_off_outlined,
      AppStatusTone.notConfigured => Icons.tune_outlined,
      AppStatusTone.neutral => Icons.info_outline,
    };
  }
}
