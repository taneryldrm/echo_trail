// EchoTrail MVP Flutter Uygulama
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'models/note_model.dart';
import 'main_menu.dart';
import 'add_note_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notesBox');

  runApp(EchoTrailApp());
}

class EchoTrailApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EchoTrail',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainMenu(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController _mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadSavedNotes();
    _getCurrentLocation();
  }

  void _loadSavedNotes() {
    final box = Hive.box<Note>('notesBox');
    for (var note in box.values) {
      _markers.add(Marker(
        markerId: MarkerId(DateTime.now().toIso8601String()),
        position: LatLng(note.lat, note.lng),
        onTap: () => _showNoteDialog(note.text),
      ));
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
      _markers.add(Marker(
        markerId: MarkerId("current_location"),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(title: "Bulunduğun Nokta"),
      ));
    });
  }

  void _showNoteDialog(String text) {
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
      appBar: AppBar(title: Text('EchoTrail')),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          zoom: 15,
        ),
        myLocationEnabled: true,
        onMapCreated: (controller) {
          _mapController = controller;
        },
        markers: _markers,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_currentPosition == null) return;

          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNotePage(position: _currentPosition!),
            ),
          );

          if (result != null && result is Map) {
            final note = result['note'];
            final lat = result['lat'];
            final lng = result['lng'];

            setState(() {
              _markers.add(Marker(
                markerId: MarkerId(DateTime.now().toIso8601String()),
                position: LatLng(lat, lng),
                infoWindow: InfoWindow(title: note),
              ));
            });
            final box = Hive.box<Note>('notesBox');
            box.add(Note(text: note, lat: lat, lng: lng));
          }
        },
        child: Icon(Icons.edit_location_alt),
        tooltip: "Anı Bırak",
      ),
    );
  }
}