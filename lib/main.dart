import 'package:every_read/features/app/repositories/app_settings_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/app/bloc/app_settings_bloc.dart';
import 'features/app/every_read_app.dart';

void main() {
  runApp(
   RepositoryProvider<AppSettingsRepository>(
     create: (context) => AppSettingsRepository(),
     child: BlocProvider<AppSettingsBloc>(
       create: (context) => AppSettingsBloc(
         AppSettingsLoading(),
         context.read<AppSettingsRepository>()
       )..add(AppSettingsLoad()),
       child: const EveryRead()
     )
   )
  );
}