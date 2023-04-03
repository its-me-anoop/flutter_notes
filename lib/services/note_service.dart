// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';
import '../models/text_note.dart';
import '../models/image_note.dart';

class NoteService {
  List<Note> _notes = [];

  NoteService() {
    _loadNotesFromPrefs();
  }

  List<Note> getNotes() {
    return _notes;
  }

  Future<void> _loadNotesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getString('notes') ?? '[]';
    final notesList = jsonDecode(notesJson) as List;
    _notes = notesList.map((note) {
      if (note['image'] != null) {
        return ImageNote.fromJson(note);
      } else {
        return TextNote.fromJson(note);
      }
    }).toList();
  }

  Future<void> _saveNotesToPrefs() async {
    final notesList =
        _notes.map((note) => (note as TextNote).toJson()).toList();
    final notesJson = jsonEncode(notesList);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('notes', notesJson);
  }

  void addNote(Note note) {
    _notes.add(note);
    _saveNotesToPrefs();
  }

  void updateNote(String id, Note updatedNote) {
    int index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes[index] = updatedNote;
      _saveNotesToPrefs();
    }
  }

  void deleteNote(String id) {
    _notes.removeWhere((note) => note.id == id);
    _saveNotesToPrefs();
  }
}
