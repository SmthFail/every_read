import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/models/document_model.dart';
import '../../../common/result_class.dart';
import '../../custom_file_picker/repositories/file_repository.dart';
import '../bloc/home_page_bloc.dart';

class DocumentCard extends StatelessWidget {
  final DocumentModel document;
  const DocumentCard({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 10,
      child: ListTile(
          title: Text(document.name),
          subtitle: Text("Path: ${document.filePath}, progress: ${document.currentPosition} of ${document.docLength}"),
          onTap: () async {
            Result<DocumentModel, Exception> result = await FileRepository.openFileByPath(document);
            switch (result) {
              case Success<DocumentModel, Exception>(value: DocumentModel doc):
                if (context.mounted) {
                  BlocProvider.of<HomePageBloc>(context).add(
                      SetCurrentDoc(doc)); // TODO: Handle this case.
                }
              case Failure<DocumentModel, Exception>():
                // TODO: Handle this case.
                throw UnimplementedError();
            }

          }
      )
    );
  }

}