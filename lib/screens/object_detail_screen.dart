import 'package:flutter/material.dart';
import '../models/found_object.dart';

class ObjectDetailScreen extends StatelessWidget {
  final FoundObject foundObject;

  ObjectDetailScreen({required this.foundObject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'objet trouvé'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Theme.of(context).cardColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 2.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.category, color: Colors.blue, size: 30),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        foundObject.category,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.green, size: 24),
                    SizedBox(width: 10),
                    Text(
                      'Gare : ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        foundObject.station,
                        style: TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.orange, size: 24),
                    SizedBox(width: 10),
                    Text(
                      'Date : ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      foundObject.date
                          .toLocal()
                          .toIso8601String()
                          .substring(0, 10),
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      foundObject.restitutionDate != null
                          ? Icons.check_circle_outline
                          : Icons.cancel_outlined,
                      color: foundObject.restitutionDate != null
                          ? Colors.green
                          : Colors.red,
                      size: 24,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Restitué : ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      foundObject.restitutionDate != null ? 'Oui' : 'Non',
                      style: TextStyle(
                        fontSize: 16,
                        color: foundObject.restitutionDate != null
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
