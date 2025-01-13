part of 'app_settings_bloc.dart';

sealed class AppSettingsState {}

final class AppSettingsLoading extends AppSettingsState {}

final class AppSettingsReady extends AppSettingsState {}

final class AppSettingsFailure extends AppSettingsState {
  final String errorMessage;

  AppSettingsFailure(this.errorMessage);
}
