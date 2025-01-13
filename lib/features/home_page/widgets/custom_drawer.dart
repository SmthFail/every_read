import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../app/bloc/app_settings_bloc.dart';
import '../../app/repositories/app_settings_repository.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(5),
        children: [
          const DrawerHeader(
            child: Text("EveryRead Menu"),
          ),
          BlocBuilder<AppSettingsBloc, AppSettingsState>(
            buildWhen: (context, state) {
              if (state is AppSettingsReady) {
                return true;
              }
              return false;
            },
            builder: (context, state) {
              if (state is AppSettingsReady) {
                return SwitchListTile(
                  title: const Text("NightMode"),
                    value: context.read<AppSettingsRepository>().themeMode == ThemeMode.dark ? true : false,
                    secondary: const Icon(Icons.nightlight_outlined),
                    onChanged: (bool value) {
                      context.read<AppSettingsBloc>().add(AppSettingsSwitchTheme());
                    });
              }
              return Container();
            }
          ),
            const Divider(),
            AboutListTile(
              applicationIcon: Image.asset(
                  "assets/icons/logo.png", width: 45, height: 45),
              applicationName: "EveryRead",
              applicationVersion: "0.1.1", // TODO move to Future builder of bloc?
              aboutBoxChildren: const [
                Text("App for reading various type of files. Enjoy!"),
                Text("Supported formats: pdf, fb2")
              ],
          ),
        ]
      )
    );
  }
}
