import 'dart:io';

import 'package:every_read/features/custom_file_picker/data_source/android_file_data_source.dart';
import 'package:every_read/features/custom_file_picker/data_source/desktop_file_data_source.dart';

import '../../../common/models/document_model.dart';
import '../../../common/result_class.dart';

class FileRepository {

  /// Create dialog and open file
  static Future<Result<DocumentModel, Exception>> openFileWithDialog() async {
    if (Platform.isAndroid) {
      return await AndroidFileDataSource.openFilePicker();
    }
    if (Platform.isWindows || Platform.isLinux) {
      return await DesktopFileDataSource.openFilePicker();
    }
    return Failure(Exception("Unimplemented"));
  }

  /// Open file by path for desktop or uri (provided as String) for Android
  static Future<Result<DocumentModel, Exception>> openFileByPath(DocumentModel doc) async {
    if (Platform.isAndroid) {
      return await AndroidFileDataSource.openFileByPath(doc);
    }
    if (Platform.isWindows || Platform.isLinux) {
      return await DesktopFileDataSource.openFileByPath(doc);
    }
    return Failure(Exception("Unimplemented"));
  }
}