abstract class Note {
  final String id;
  final DateTime dateCreated;
  final DateTime dateModified;

  Note({
    required this.id,
    required this.dateCreated,
    required this.dateModified,
  });
}
