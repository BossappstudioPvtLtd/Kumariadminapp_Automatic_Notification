import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kumari_admin_web/Com/driverdata.dart';
import 'driver.dart'; // Import the Driver model class

class DriverListPage extends StatefulWidget {
  const DriverListPage({super.key});

  @override
  State<DriverListPage> createState() => _DriverListPageState();
}

class _DriverListPageState extends State<DriverListPage> {
  Future<List<Driver>> fetchDrivers() async {
    final databaseReference = FirebaseDatabase.instance.ref('drivers');
    final snapshot = await databaseReference.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      final List<Driver> drivers = [];
      data.forEach((key, value) {
        final driver = Driver.fromMap(value);
        drivers.add(driver);
      });
      return drivers;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<List<Driver>>(
        future: fetchDrivers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No drivers found.'));
          } else {
            final drivers = snapshot.data!;
            return ListView.builder(
              itemCount: drivers.length,
              itemBuilder: (context, index) {
                final driver = drivers[index];
                return ListTile(
                  title: Text(driver.name),
                  subtitle: Text('Phone: ${driver.phone}'),
                  trailing: Text(driver.id),
                );
              },
            );
          }
        },
      
    );
  }
}
