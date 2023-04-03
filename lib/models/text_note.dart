import 'dart:io';
import 'note.dart';

class TextNote extends Note {
  final List<dynamic> content;

  TextNote({
    required String id,
    required DateTime dateCreated,
    required DateTime dateModified,
    required this.content,
  }) : super(id: id, dateCreated: dateCreated, dateModified: dateModified);

  factory TextNote.fromJson(Map<String, dynamic> json) {
    return TextNote(
      id: json['id'],
      dateCreated: DateTime.parse(json['dateCreated']),
      dateModified: DateTime.parse(json['dateModified']),
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateCreated': dateCreated.toIso8601String(),
      'dateModified': dateModified.toIso8601String(),
      'content': content,
    };
  }
}
