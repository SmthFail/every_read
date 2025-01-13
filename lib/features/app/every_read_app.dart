import 'package:every_read/features/app/repositories/app_settings_repository.dart';
import 'package:every_read/features/fb2_reader/bloc/fb2_reader_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/routes_class.dart';
import '../fb2_reader/fb2_reader_builder.dart';
import '../home_page/bloc/home_page_bloc.dart';
import '../home_page/home_page_builder.dart';
import '../pdf_reader/pdf_reader.dart';
import '../txt_viewer/txt_viewer.dart';
import 'bloc/app_settings_bloc.dart';


class EveryRead extends StatelessWidget {
  const EveryRead({super.key});

  @override
  Widget build(BuildContext context) {

    buildErrorScreen(String errorMessage) {
      return Scaffold(
        body: Center(
          child: Text("Error while load app.\n"
              "Error: $errorMessage")
        )
      );
    }


    buildApp() {
      return  MaterialApp(
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue, brightness: Brightness.light),
            useMaterial3: true,
        ),
        darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue, brightness: Brightness.dark),
            useMaterial3: true,
        ),
        themeMode: RepositoryProvider.of<AppSettingsRepository>(context).themeMode,
        routes: {
          RoutesClass.home: (context) => _configureHomePath(),
          RoutesClass.pdfViewer: (context) => const PDFReader(),
          RoutesClass.fb2Viewer: (context) => _configureFb2ViewerPath(),
          RoutesClass.txtViewer: (context) => const TxtViewer()
        },
        initialRoute: RoutesClass.home,
      );
    }

    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      builder: (context, state) {
        if (state is AppSettingsFailure) {
          return buildErrorScreen(state.errorMessage);
        }
        if (state is AppSettingsReady) {
          return buildApp();
        }
        return Container();
      }
    );

  }

  BlocProvider<HomePageBloc> _configureHomePath() {
    return BlocProvider(
        create: (context) => HomePageBloc(
            HomePageLoading(),
            RepositoryProvider.of<AppSettingsRepository>(context)
        )..add(LoadPrevious()),
        child: const HomePageBuilder()
    );
  }


  BlocProvider<Fb2ReaderBloc> _configureFb2ViewerPath() {
    return BlocProvider(
        create: (context) =>
        Fb2ReaderBloc(
            Fb2ReaderLoading(),
            RepositoryProvider.of<AppSettingsRepository>(context)
        )
          ..add(Fb2ReaderLoadBook()),
        child: const Fb2ReaderBuilder()
    );
  }
}


