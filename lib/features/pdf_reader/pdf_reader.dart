import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../common/routes_class.dart';
import '../app/repositories/app_settings_repository.dart';

class PDFReader extends StatefulWidget {
  const PDFReader({super.key});

  @override
  State<PDFReader> createState() => PDFReaderState();
}

class PDFReaderState extends State<PDFReader> {
  final controller = PdfViewerController();
  bool docInited = false;


  @override
  Widget build(BuildContext context) {
    AppSettingsRepository appSettingsRepository = RepositoryProvider.of<AppSettingsRepository>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            appSettingsRepository.clearCurrentDocument();
            Navigator.of(context).pushReplacementNamed(RoutesClass.home);
          },
        ),
      ),
      body: PdfViewer.data(
        appSettingsRepository.currentDocument!.fileContent!,
        initialPageNumber: appSettingsRepository.currentDocument!.currentPosition,
        sourceName: "Source name",
        controller: controller,
        params: PdfViewerParams(
          viewerOverlayBuilder: (context, size, handleLinkTap) => [
            PdfViewerScrollThumb(
              controller: controller,
              orientation: ScrollbarOrientation.right,
              thumbSize: const Size(40, 25),
              thumbBuilder: (context, thumbSize, pageNumber, controller) =>
                 Container(
                   padding: const EdgeInsets.all(4.0),
                   decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(16.0),
                   ),
                   child: Center(child: Text(pageNumber.toString(),
                     style: const TextStyle(color: Colors.black)
                   ))
                ),
            ),
          ],
          loadingBannerBuilder:
              (context, bytesDownloaded, totalBytes) => Center(
            child: CircularProgressIndicator(
              value: totalBytes != null
                  ? bytesDownloaded / totalBytes
                  : null,
              backgroundColor: Colors.grey,
            ),
          ),
          onPageChanged: (int? newPage) {
            if (docInited) {
              appSettingsRepository.updateCurrentDocument(
                  appSettingsRepository.currentDocument!.copyWith(
                      currentPosition: controller.pageNumber)
              );
            }
          },
          onViewerReady: (document, controller) async {
            appSettingsRepository.updateCurrentDocument(
                appSettingsRepository.currentDocument!.copyWith(
                  currentPosition: controller.pageNumber,
                  docLength: controller.pageCount
                )
            );
            docInited = true;
          },
        )
      ),
    );
  }

}

