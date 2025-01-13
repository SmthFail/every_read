import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

part 'document_model.g.dart';

@JsonSerializable()
class DocumentModel {
  DocumentModel({
    required this.name,
    required this.filePath,
    this.currentPosition = 0,
    this.docLength,
    this.fileContent
  });

  String name;
  String filePath;
  int currentPosition;
  int? docLength;
  @JsonKey(includeToJson: false, includeFromJson: false)
  Uint8List? fileContent;


  factory DocumentModel.fromJson(Map<String, dynamic> json) => _$DocumentModelFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentModelToJson(this);

  DocumentModel copyWith({
        String? name,
        String? filePath,
        int? currentPosition,
        int? docLength,
        Uint8List? fileContent,
      }) {
      return DocumentModel(
          name: name ?? this.name,
          filePath: filePath ?? this.filePath,
          currentPosition:  currentPosition ?? this.currentPosition,
          docLength: docLength ?? this.docLength,
          fileContent: fileContent ?? this.fileContent
      );
  }
}