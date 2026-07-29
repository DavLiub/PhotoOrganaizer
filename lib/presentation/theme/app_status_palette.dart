import 'package:flutter/material.dart';

enum AppStatusTone {
  protected,
  queued,
  inProgress,
  failed,
  ignored,
  notConfigured,
  neutral,
}

class StatusToneStyle {
  const StatusToneStyle({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;

  static StatusToneStyle lerp(
    StatusToneStyle left,
    StatusToneStyle right,
    double value,
  ) {
    return StatusToneStyle(
      background: Color.lerp(left.background, right.background, value)!,
      foreground: Color.lerp(left.foreground, right.foreground, value)!,
      border: Color.lerp(left.border, right.border, value)!,
    );
  }
}

class AppStatusPalette extends ThemeExtension<AppStatusPalette> {
  const AppStatusPalette({
    required this.protectedTone,
    required this.queuedTone,
    required this.inProgressTone,
    required this.failedTone,
    required this.ignoredTone,
    required this.notConfiguredTone,
    required this.neutralTone,
  });

  static const light = AppStatusPalette(
    protectedTone: StatusToneStyle(
      background: Color(0xFFDCFCE7),
      foreground: Color(0xFF166534),
      border: Color(0xFF86EFAC),
    ),
    queuedTone: StatusToneStyle(
      background: Color(0xFFFEF3C7),
      foreground: Color(0xFF92400E),
      border: Color(0xFFFCD34D),
    ),
    inProgressTone: StatusToneStyle(
      background: Color(0xFFDBEAFE),
      foreground: Color(0xFF1D4ED8),
      border: Color(0xFF93C5FD),
    ),
    failedTone: StatusToneStyle(
      background: Color(0xFFFEE2E2),
      foreground: Color(0xFF991B1B),
      border: Color(0xFFFCA5A5),
    ),
    ignoredTone: StatusToneStyle(
      background: Color(0xFFF3F4F6),
      foreground: Color(0xFF4B5563),
      border: Color(0xFFD1D5DB),
    ),
    notConfiguredTone: StatusToneStyle(
      background: Color(0xFFFFEDD5),
      foreground: Color(0xFF9A3412),
      border: Color(0xFFFDBA74),
    ),
    neutralTone: StatusToneStyle(
      background: Color(0xFFE0F2FE),
      foreground: Color(0xFF075985),
      border: Color(0xFF7DD3FC),
    ),
  );

  final StatusToneStyle protectedTone;
  final StatusToneStyle queuedTone;
  final StatusToneStyle inProgressTone;
  final StatusToneStyle failedTone;
  final StatusToneStyle ignoredTone;
  final StatusToneStyle notConfiguredTone;
  final StatusToneStyle neutralTone;

  StatusToneStyle resolve(AppStatusTone tone) {
    return switch (tone) {
      AppStatusTone.protected => protectedTone,
      AppStatusTone.queued => queuedTone,
      AppStatusTone.inProgress => inProgressTone,
      AppStatusTone.failed => failedTone,
      AppStatusTone.ignored => ignoredTone,
      AppStatusTone.notConfigured => notConfiguredTone,
      AppStatusTone.neutral => neutralTone,
    };
  }

  @override
  AppStatusPalette copyWith({
    StatusToneStyle? protectedTone,
    StatusToneStyle? queuedTone,
    StatusToneStyle? inProgressTone,
    StatusToneStyle? failedTone,
    StatusToneStyle? ignoredTone,
    StatusToneStyle? notConfiguredTone,
    StatusToneStyle? neutralTone,
  }) {
    return AppStatusPalette(
      protectedTone: protectedTone ?? this.protectedTone,
      queuedTone: queuedTone ?? this.queuedTone,
      inProgressTone: inProgressTone ?? this.inProgressTone,
      failedTone: failedTone ?? this.failedTone,
      ignoredTone: ignoredTone ?? this.ignoredTone,
      notConfiguredTone: notConfiguredTone ?? this.notConfiguredTone,
      neutralTone: neutralTone ?? this.neutralTone,
    );
  }

  @override
  AppStatusPalette lerp(ThemeExtension<AppStatusPalette>? other, double value) {
    if (other is! AppStatusPalette) {
      return this;
    }

    return AppStatusPalette(
      protectedTone: StatusToneStyle.lerp(
        protectedTone,
        other.protectedTone,
        value,
      ),
      queuedTone: StatusToneStyle.lerp(queuedTone, other.queuedTone, value),
      inProgressTone: StatusToneStyle.lerp(
        inProgressTone,
        other.inProgressTone,
        value,
      ),
      failedTone: StatusToneStyle.lerp(failedTone, other.failedTone, value),
      ignoredTone: StatusToneStyle.lerp(ignoredTone, other.ignoredTone, value),
      notConfiguredTone: StatusToneStyle.lerp(
        notConfiguredTone,
        other.notConfiguredTone,
        value,
      ),
      neutralTone: StatusToneStyle.lerp(neutralTone, other.neutralTone, value),
    );
  }
}

extension AppStatusTheme on BuildContext {
  AppStatusPalette get statusPalette {
    return Theme.of(this).extension<AppStatusPalette>() ??
        AppStatusPalette.light;
  }
}
