import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/models/app_settings.dart';
import '../../domain/value_objects/operation_result.dart';
import 'app_providers.dart';
import 'app_settings_actions.dart';
import 'app_settings_state.dart';

final appSettingsProvider =
    NotifierProvider<AppSettingsController, AppSettingsState>(
      AppSettingsController.new,
    );

class AppSettingsController extends Notifier<AppSettingsState> {
  late final AppSettingsActions _actions;

  @override
  AppSettingsState build() {
    _actions = ref.watch(appSettingsActionsProvider);
    unawaited(Future<void>.microtask(load));
    return const AppSettingsState.initial();
  }

  Future<void> load() async {
    state = state.copyWith(phase: AppSettingsPhase.loading, clearError: true);

    final result = await _actions.readSettings();
    switch (result) {
      case OperationSuccess<AppSettings>(value: final value):
        state = state.copyWith(
          phase: AppSettingsPhase.loaded,
          settings: value,
          clearError: true,
        );
      case OperationFailure<AppSettings>(failure: final failure):
        state = state.copyWith(
          phase: AppSettingsPhase.failure,
          errorCode: failure.safeMessage ?? failure.code,
        );
    }
  }

  Future<void> selectLocale(String localeCode) async {
    final nextSettings = state.settings.withSelectedLocale(localeCode);
    state = state.copyWith(
      phase: AppSettingsPhase.saving,
      settings: nextSettings,
      clearError: true,
    );

    final result = await _actions.saveLocale(localeCode);
    switch (result) {
      case OperationSuccess<AppSettings>(value: final value):
        state = state.copyWith(
          phase: AppSettingsPhase.loaded,
          settings: value,
          clearError: true,
        );
      case OperationFailure<AppSettings>(failure: final failure):
        state = state.copyWith(
          phase: AppSettingsPhase.failure,
          errorCode: failure.safeMessage ?? failure.code,
        );
    }
  }
}
