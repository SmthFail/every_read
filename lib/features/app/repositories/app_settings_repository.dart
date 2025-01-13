import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/models/document_model.dart';
import '../../../common/result_class.dart';


class AppSettingsRepository {
  static const String storageKey = "every_read_storage";
  static const String settingsKey = "every_read_settings";
  DocumentModel? _currentDocument;
  List<DocumentModel> previousLoaded = [];
  Timer? saveTimer;

  ThemeMode themeMode = ThemeMode.light; // TODO?

  Future<Result<bool, Exception>> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // TODO mode to separate repos and add try catch
    String? appSettings = prefs.getString(settingsKey);
    if (appSettings == null) {
      themeMode = ThemeMode.light;
      return const Success(true);
    }
    if (appSettings == "light") {
      themeMode = ThemeMode.light;
      return const Success(true);
    }
    else {
      themeMode = ThemeMode.dark;
      return const Success(true);
    }
  }

  void switchTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // TODO mode to separate repos and add try catch
    if (themeMode == ThemeMode.dark) {
      themeMode = ThemeMode.light;
      prefs.setString(settingsKey, "light");
      return;
    }
    themeMode = ThemeMode.dark;
    prefs.setString(settingsKey, "dark");
  }


  Future<Result<List<DocumentModel>, Exception>> getPreviousDocuments() async {
    try {
      if (previousLoaded.isEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        String? previousData = prefs.getString(storageKey);
        previousLoaded = previousData != null
            ? List.from((jsonDecode(previousData))
            .map((item) => DocumentModel.fromJson(item)))
        // TODO check out of hadnling error with this line. Get async errors
        //   ? (jsonDecode(previousData))
        //   .map((item) => DocumentModel.fromJson(item)).toList()
            : [];
      }
      return Success(previousLoaded);
    } on Exception catch (e) {
      return Failure(e);
    }
  }


  bool setCurrentDocument(DocumentModel document ) {
    try {
      saveTimer ??= Timer.periodic(const Duration(seconds: 5), (timer) {
        saveToStorage();
      });
      _currentDocument = document;
      return true; // TODO
    } on Exception catch (e) {
      debugPrint("Exception while try to start save timer: $e");
      return false;
    }
  }

  DocumentModel? get currentDocument => _currentDocument;

  void clearCurrentDocument() {
    if (saveTimer != null) {
      saveTimer!.cancel();
      saveTimer = null;
      saveToStorage();
    }
    _currentDocument = null;
  }

  void updateCurrentDocument(DocumentModel doc) {
    _currentDocument = doc;
  }

  Future<bool> clearHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool res = await prefs.clear();
    if (res) {
      previousLoaded.clear();
      return true;
    }
    return false;
  }

  bool _checkForSaving() {
    if (previousLoaded.isEmpty && _currentDocument != null) {
      previousLoaded = [_currentDocument!];
      return true;
    }
    if (previousLoaded.first == _currentDocument) {
      return false;
    }
    previousLoaded.removeWhere((item) => item.filePath == _currentDocument!.filePath);
    previousLoaded = [_currentDocument!] + previousLoaded;
    return true;
  }

  void saveToStorage() async {
    if (_checkForSaving()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(storageKey, jsonEncode(previousLoaded));
    }
  }

}