import 'package:flutter/material.dart';
import '../services/note_service.dart';
import '../models/note.dart';

class NotesProvider with ChangeNotifier {
  final NoteService _noteService = NoteService();

  List<Note> get notes => _noteService.getNotes();

  void addNote(Note note) {
    _noteService.addNote(note);
    notifyListeners();
  }

  void updateNote(String id, Note updatedNote) {
    _noteService.updateNote(id, updatedNote);
    notifyListeners();
  }

  void deleteNote(String id) {
    _noteService.deleteNote(id);
    notifyListeners();
  }
}
