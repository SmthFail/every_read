
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/result_class.dart';
import '../repositories/app_settings_repository.dart';

part 'app_settings_event.dart';
part 'app_settings_state.dart';

class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  AppSettingsRepository appSettingsRepository;
  AppSettingsBloc(super.initialState, this.appSettingsRepository) {
    on<AppSettingsEvent>((event, emit) async  {
      switch (event) {
        case AppSettingsLoad():
          await _handleAppSettingsLoad(event, emit);
        case AppSettingsSwitchTheme():
          await _handleAppSettingsSwitchTheme(event, emit);
      }
    });
  }

  _handleAppSettingsLoad(AppSettingsLoad event, Emitter<AppSettingsState> emit) async {
    emit(AppSettingsLoading());
    Result<bool, Exception> result = await appSettingsRepository.loadSettings();
    switch (result) {
      case Success<bool, Exception>():
        emit(AppSettingsReady());
      case Failure<bool, Exception>(exception: Exception exc):
        emit(AppSettingsFailure(exc.toString()));
    }
  }

  _handleAppSettingsSwitchTheme(AppSettingsSwitchTheme event, Emitter<AppSettingsState> emit) async {
    appSettingsRepository.switchTheme(); // TODO better handling?
    emit(AppSettingsReady());
  }
}
