import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';
import '../models/text_note.dart';
import '../widgets/inline_image_text_widget.dart';

class TextNoteEditorScreen extends StatefulWidget {
  final TextNote? note;

  TextNoteEditorScreen({this.note});

  @override
  _TextNoteEditorScreenState createState() => _TextNoteEditorScreenState();
}

class _TextNoteEditorScreenState extends State<TextNoteEditorScreen> {
  List<dynamic> _content = [];
  String? _noteId;
  late DateTime _dateCreated;
  late DateTime _dateModified;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _noteId = widget.note!.id;
      _content = widget.note!.content;
      _dateCreated = widget.note!.dateCreated;
      _dateModified = widget.note!.dateModified;
    } else {
      _noteId = null;
      _dateCreated = DateTime.now();
      _dateModified = _dateCreated;
      _content.add(''); // Initialize with an empty string
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _content.add(File(pickedFile.path));
        _content.add('');
      });
    }
  }

  void _onTextChanged(int index, String text) {
    setState(() {
      _content[index] = text;
    });
  }

  void _onImageAdded(int index, File image) {
    setState(() {
      _content.insert(index + 1, image);
      _content.insert(index + 2, '');
    });
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Note Editor'),
        actions: [
          IconButton(
            icon: Icon(Icons.image),
            onPressed: _pickImage,
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if (_noteId == null) {
                final newNote = TextNote(
                  id: DateTime.now().toIso8601String(),
                  dateCreated: _dateCreated,
                  dateModified: DateTime.now(),
                  content: _content,
                );
                notesProvider.addNote(newNote);
              } else {
                final updatedNote = TextNote(
                  id: _noteId!,
                  dateCreated: _dateCreated,
                  dateModified: DateTime.now(),
                  content: _content,
                );
                notesProvider.updateNote(_noteId!, updatedNote);
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: InlineImageTextWidget(
            content: _content,
            onTextChanged: _onTextChanged,
            onImageAdded: _onImageAdded,
          ),
        ),
      ),
    );
  }
}
