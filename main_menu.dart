import 'package:flutter/material.dart';
import 'models/notes_list_page.dart';
// Bu sayfayı birazdan oluşturacağız

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ana Menü')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/map'); // harita için
              },
              child: Text("Haritayı Aç"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotesListPage()),
                );
              },
              child: Text("Anılarım"),
            ),
          ],
        ),
      ),
    );
  }
}
