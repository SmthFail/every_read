import 'dart:core';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

import '../../../common/models/document_model.dart';
import '../../../common/result_class.dart';

class DesktopFileDataSource {

  static Future<Result<DocumentModel, Exception>> openFilePicker() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'txt', 'fb2'],
        withData: true
      );
      if (result!= null) {
        Uint8List? fileContent = result.files.first.bytes;
        if (fileContent == null) {
          return Failure(Exception("Can't get file content"));
        }
        return Success(DocumentModel(
            name: result.files.first.name,
            filePath: result.files.first.path!,
            fileContent: fileContent
        )
        );
      }
      return Failure(Exception("Can't get file location (uri is null)"));
    } on PlatformException catch (e) {
      return Failure(Exception("Error in pick file: ${e.message}"));
    }
  }

  static Future<Result<DocumentModel, Exception>> openFileByPath(DocumentModel doc) async {
      try {
        final file = File(doc.filePath);
        if (await file.exists()) {
          Uint8List? fileContent = await file.readAsBytes();
          return Success(doc.copyWith(fileContent: fileContent));
        } else {
          return Failure(Exception("File didn't exist"));
        }
      } catch (e) {
        return Failure(Exception("Error while read file: $e"));
      }
  }
}