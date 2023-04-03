import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/notes_provider.dart';
import 'text_note_editor_screen.dart';
import '../models/text_note.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: ListView.builder(
        itemCount: notesProvider.notes.length,
        itemBuilder: (ctx, i) {
          final note = notesProvider.notes[i] as TextNote;
          final lastModifiedDate =
              DateFormat.yMMMd().add_jm().format(note.dateModified);

          String title = '';
          String subtitle = '';
          File? thumbnail;

          for (var element in note.content) {
            if (element is File && thumbnail == null) {
              thumbnail = element;
            } else if (element is String) {
              if (title.isEmpty) {
                title = element;
              } else {
                subtitle = element;
                break;
              }
            }
          }

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: thumbnail != null
                  ? Image.file(
                      thumbnail,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    )
                  : null,
              title: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Last modified: $lastModifiedDate',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => TextNoteEditorScreen(
                      note: notesProvider.notes[i] as TextNote,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => TextNoteEditorScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
