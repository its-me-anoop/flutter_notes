import 'dart:io';
import 'note.dart';

class ImageNote extends Note {
  final File image;

  ImageNote({
    required String id,
    required DateTime dateCreated,
    required DateTime dateModified,
    required this.image,
  }) : super(id: id, dateCreated: dateCreated, dateModified: dateModified);

  factory ImageNote.fromJson(Map<String, dynamic> json) {
    return ImageNote(
      id: json['id'],
      dateCreated: DateTime.parse(json['dateCreated']),
      dateModified: DateTime.parse(json['dateModified']),
      image: File(json['image']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateCreated': dateCreated.toIso8601String(),
      'dateModified': dateModified.toIso8601String(),
      'image': image.path,
    };
  }
}
