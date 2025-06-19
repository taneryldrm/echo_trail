import 'package:hive/hive.dart';
part 'note_model.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  late String text;

  @HiveField(1)
  late double lat;

  @HiveField(2)
  late double lng;

  Note({required this.text, required this.lat, required this.lng});
}
