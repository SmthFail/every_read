import 'package:every_read/features/app/repositories/app_settings_repository.dart';
import 'package:every_read/features/home_page/widgets/last_document_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/models/document_model.dart';
import '../../../common/result_class.dart';
import '../../custom_file_picker/repositories/file_repository.dart';
import '../bloc/home_page_bloc.dart';
import 'custom_drawer.dart';

class HomePage extends StatelessWidget {
  final List<DocumentModel> previousDocs;
  const HomePage({super.key, required this.previousDocs});

  @override
  Widget build(BuildContext context) {

      Future<void> pickFile() async {
        Result<DocumentModel, Exception> result = await FileRepository.openFileWithDialog();
        switch (result) {
          case Success<DocumentModel, Exception>(value: DocumentModel doc):
            if (context.mounted) {
            BlocProvider.of<HomePageBloc>(context)
                .add(SetCurrentDoc(doc));
            }
          case Failure<DocumentModel?, Exception>():
            // TODO: Handle this case.
            throw UnimplementedError();
        }
      }


      return Scaffold(
        appBar: AppBar(
          title: const Text("Every Read"),
          centerTitle: true,
        ),
        drawer: const CustomDrawer(),
        body: SingleChildScrollView(child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
              children: [
                if (previousDocs.isNotEmpty)
                      ...List.from(previousDocs.map((item) => DocumentCard(document: item)))
                else
                  const Center(child: Text("You are not open files yet!"))
              ]
            ))
        )),
        persistentFooterButtons: [
          IconButton(
            icon: const Icon(Icons.folder_open_outlined),
            onPressed: pickFile,
            tooltip: "Open new",
          ),
          IconButton(
            icon: const Icon(Icons.clear_outlined, color: Colors.red),
            onPressed: () async {
              // TODO temporaly. Move to settings in navigator
              bool res = await RepositoryProvider.of<AppSettingsRepository>(context).clearHistory();
              if (res) {
                if (context.mounted) {
                  BlocProvider.of<HomePageBloc>(context).add(LoadPrevious());
                }
              }
            },
            tooltip: "Clear history"
          )
        ],
        persistentFooterAlignment: AlignmentDirectional.center,
      );
  }

}