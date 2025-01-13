import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common/models/document_model.dart';
import '../../../common/result_class.dart';

class AndroidFileDataSource{
  static const MethodChannel _channel = MethodChannel('com.every_apps.every_read/file_selector');

  static Future<Result<DocumentModel, Exception>> openFilePicker() async {
    bool hasPermission = await requestStoragePermission();
    if (!hasPermission) {
      return Failure(Exception("Not permission to read file"));
    }

    try {
      final String? uri = await _channel.invokeMethod('openFilePicker');
      if (uri != null) {
        Uint8List? fileContent = await readFileFromUri(uri);
        if (fileContent == null) {
          return Failure(Exception("Can't get file content"));
        }
        String fileName = await _channel.invokeMethod("getFileName", {"uri": uri});
        return Success(DocumentModel(
          name: fileName,
          filePath: uri,
          fileContent: fileContent
        )
        );
      }
      return Failure(Exception("Can't get file location (uri is null)"));
    } on PlatformException catch (e) {
      return Failure(Exception("Error in pick file: ${e.message}"));
    }
  }

  static Future<Uint8List?> readFileFromUri(String uri) async {
    final Uint8List? bytes = await _channel.invokeMethod(
        "readFileBytes", {'uri': uri});
      return bytes;
  }

  static Future<Result<DocumentModel, Exception>> openFileByPath(DocumentModel doc) async {
    bool hasPermission = await requestStoragePermission();
    if (!hasPermission) {
      return Failure(Exception("Not permission to read file"));
    }

    try {
      Uint8List? fileContent = await readFileFromUri(doc.filePath);
      if (fileContent == null) {
        return Failure(Exception("Can't read file content: it's null"));
      }
      return Success(
        doc.copyWith(fileContent: fileContent)
      );
    } on Exception catch (e) {
      return Failure(Exception("Error in read file $e"));
    }
  }

  static Future<bool> requestStoragePermission() async {
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }

    if (await Permission.manageExternalStorage.isDenied) {
      PermissionStatus status = await Permission.manageExternalStorage.request();
      if (status.isGranted) {
        return true;
      } else if (status.isPermanentlyDenied) {
        await openAppSettings();
        return false;
      }
    }

    // for Android below 11
    if (await Permission.storage.isGranted) {
      return true;
    }

    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    return false;
  }
}