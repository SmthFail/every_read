// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentModel _$DocumentModelFromJson(Map<String, dynamic> json) =>
    DocumentModel(
      name: json['name'] as String,
      filePath: json['filePath'] as String,
      currentPosition: (json['currentPosition'] as num?)?.toInt() ?? 0,
      docLength: (json['docLength'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DocumentModelToJson(DocumentModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'filePath': instance.filePath,
      'currentPosition': instance.currentPosition,
      'docLength': instance.docLength,
    };
