import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Earingsdata extends StatefulWidget {
  const Earingsdata({super.key});

  @override
  State<Earingsdata> createState() => _EaringsdataState();
}

class _EaringsdataState extends State<Earingsdata> {
  final completedTripsRecordsFromDatabase =
      FirebaseDatabase.instance.ref().child("tripRequests");

  // Method to show dialog with driver's details
  void _showDriverDetailsDialog(Map<String, dynamic> driverData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Driver Details"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text("Driver ID: ${driverData['driverID']}"),
                Text("Driver Name: ${driverData['driverName']}"),
                Text("Driver Phone: ${driverData['driverPhone']}"),
                Text("Publish Date Time: ${driverData['publishDateTime']}"),
                Text("Fare Amount: ₹ ${driverData['fareAmount']}"),
                // Add other details here
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: completedTripsRecordsFromDatabase.onValue,
      builder: (BuildContext context, snapshotData) {
        if (snapshotData.hasError) {
          return const Center(
            child: Text(
              "Error Occurred. Try Later.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Color.fromARGB(255, 4, 33, 76),
              ),
            ),
          );
        }

        if (snapshotData.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        Map dataMap = snapshotData.data!.snapshot.value as Map;
        List itemsList = [];
        dataMap.forEach((key, value) {
          itemsList.add({"key": key, ...value});
        });

        return ListView.builder(
          shrinkWrap: true,
          itemCount: itemsList.length,
          itemBuilder: ((context, index) {
            if (itemsList[index]["status"] != null &&
                itemsList[index]["status"] == "ended") {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _showDriverDetailsDialog(itemsList[index]),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        itemsList[index]["driverID"].toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      itemsList[index]["driverName"].toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      itemsList[index]["driverPhone"].toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      itemsList[index]["publishDateTime"].toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "₹ ${itemsList[index]["fareAmount"]}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text("More Details"),
                    ),
                  ),
                ],
              );
            } else {
              return Container();
            }
          }),
        );
      },
    );
  }
}
