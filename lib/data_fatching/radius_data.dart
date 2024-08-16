import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RadiusOffersPage extends StatefulWidget {
  const RadiusOffersPage({super.key});

  @override
  _RadiusOffersPageState createState() => _RadiusOffersPageState();
}

class _RadiusOffersPageState extends State<RadiusOffersPage> {
  
  final DatabaseReference _database = FirebaseDatabase.instance.ref('radiusData');
  

  Stream<List<Map<String, dynamic>>> _radiusOffersStream() {
    
    return _database.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        return data.entries.map((entry) {
          final value = entry.value as Map<dynamic, dynamic>;
          return {
            'category': value['category'],
            'radius': value['radius'],
          };
        }).toList();
      }
      return [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _radiusOffersStream(),
      builder: (context, snapshot) {
        // Display loader when the connection is waiting or in the initial state
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.none) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle errors
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Display a message when there is no data
          return const Center(child: Text('No radius offers available.'));
        } else {
          // Display the table when data is available
          final radiusOffers = snapshot.data!;
          return Table(
            border: TableBorder.all(color: Colors.white10),
            columnWidths: const {
              0: FlexColumnWidth(1), // Category column
              1: FlexColumnWidth(1), // Radius column
            },
            children: [
              const TableRow(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 12, 59, 131),
                      Color.fromARGB(255, 4, 33, 76),
                    ],
                  ),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Radius (km)',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              ...radiusOffers.map((offer) {
                return TableRow(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        offer['category'],
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        offer['radius'].toString(),
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ],
          );
        }
      },
    );
  }
}
