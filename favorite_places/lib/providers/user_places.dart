import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import '../models/Place.dart';
import 'dart:io';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY , title TEXT, image TEXT, lat REAL, lon REAL, address TEXT)');
    },
    version: 1,
  );
  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            name: row['title'] as String,
            image: File(row['image'] as String),
            location: PlaceLocation(
                latitude: row['lat'] as double,
                longitude: row['lon'] as double,
                address: row['address'] as String),
          ),
        )
        .toList();
    state = places;
  }

  void addPlace(String title, File image, PlaceLocation location) async {
    try {
      final appDir = await syspaths.getApplicationDocumentsDirectory();
      final fileName = path.basename(image.path);
      final copiedImage = await image.copy('${appDir.path}/$fileName');

      final newPlace =
          Place(name: title, image: copiedImage, location: location);

      final db = await _getDatabase();
      await db.insert('user_places', {
        'id': newPlace.id,
        'title': newPlace.name,
        'image': newPlace.image.path,
        'lat': newPlace.location.latitude,
        'lon': newPlace.location.longitude,
        'address': newPlace.location.address,
      });

      state = [newPlace, ...state];
    } catch (error) {
      print('Error adding place: $error');
    }
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
        (ref) => UserPlacesNotifier());
