import 'package:flutter/material.dart';
import '../models/found_object.dart';

class ObjectListItem extends StatelessWidget {
  final FoundObject foundObject;
  final VoidCallback onTap;

  const ObjectListItem(
      {super.key, required this.foundObject, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(foundObject.category),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Gare : ${foundObject.station}'),
          Text(
              'Date : ${foundObject.date.toLocal().toIso8601String().substring(0, 10)}'),
          Text(
              'Restitué : ${foundObject.restitutionDate != null ? "Oui" : "Non"}'),
        ],
      ),
      onTap: onTap,
    );
  }
}
