import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/Place.dart';

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  void addPlace(String title) {
    final newPlace = Place(name: title);
    state = [newPlace, ...state];
  }
}

final userPlacesProvider = StateNotifierProvider<UserPlacesNotifier, List<Place>> ((ref) => UserPlacesNotifier());