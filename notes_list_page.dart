import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'note_model.dart'; // sadece bu yeterli, diğerleri gereksiz

class NotesListPage extends StatelessWidget {
  final Box<Note> notesBox = Hive.box<Note>('notesBox');

  void _showNoteDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Anı Detayı"),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Kapat"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kaydedilen Anılar')),
      body: ValueListenableBuilder(
        valueListenable: notesBox.listenable(),
        builder: (context, Box<Note> box, _) {
          if (box.values.isEmpty) {
            return Center(child: Text("Henüz hiç anı kaydedilmedi."));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final note = box.getAt(index);
              return ListTile(
                title: Text(note?.text ?? 'Boş Anı'),
                subtitle: Text("Konum: (${note?.lat}, ${note?.lng})"),
                onTap: () => _showNoteDialog(context, note!.text),
              );
            },
          );
        },
      ),
    );
  }
}
