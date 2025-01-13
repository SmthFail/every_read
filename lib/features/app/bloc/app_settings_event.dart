part of 'app_settings_bloc.dart';

sealed class AppSettingsEvent {}

final class AppSettingsLoad extends AppSettingsEvent{}

final class AppSettingsSwitchTheme extends AppSettingsEvent {}
