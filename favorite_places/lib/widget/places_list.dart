import 'package:flutter/material.dart';

import '../models/Place.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (places.isEmpty) {
      content = Center(
        child: Text(
          "Add a new place",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      );
    } else {
      content = ListView.builder(
        itemCount: places.length,
        itemBuilder: (ctx, index) => ListTile(
          title: Text(
            places[index].name,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          ),
        ),
      );
    }

    return content;
  }
}
