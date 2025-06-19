import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class AddNotePage extends StatefulWidget {
  final Position position;

  AddNotePage({required this.position});

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController _noteController = TextEditingController();

  void _saveNote() {
    final note = _noteController.text.trim();
    if (note.isEmpty) return;

    Navigator.pop(context, {
      'note': note,
      'lat': widget.position.latitude,
      'lng': widget.position.longitude,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Anı Bırak")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Konum: ${widget.position.latitude}, ${widget.position.longitude}"),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Anını yaz",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _saveNote,
              icon: Icon(Icons.save),
              label: Text("Kaydet"),
            )
          ],
        ),
      ),
    );
  }
}
