import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kumari_admin_web/Com/common_methods.dart';
import 'package:url_launcher/url_launcher.dart';

class DriversDataList extends StatefulWidget {
  const DriversDataList({super.key});

  @override
  State<DriversDataList> createState() => _DriversDataListState();
}

class _DriversDataListState extends State<DriversDataList> {
  final driversRecordsFromDatabase = FirebaseDatabase.instance.ref().child("drivers");
  CommonMethods cMethods = CommonMethods();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: driversRecordsFromDatabase.onValue,
      builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshotData) {
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

        if (!snapshotData.hasData || snapshotData.data!.snapshot.value == null) {
          return const Center(
            child: Text(
              "No data available.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Color.fromARGB(255, 4, 33, 76),
              ),
            ),
          );
        }

        Map<dynamic, dynamic> dataMap = snapshotData.data!.snapshot.value as Map<dynamic, dynamic>;
        List<Map<String, dynamic>> itemsList = [];

        dataMap.forEach((key, value) {
          Map<String, dynamic> item = {"key": key};
          if (value is Map) {
            item.addAll(value.cast<String, dynamic>());
          }
          itemsList.add(item);
        });

        return ListView.builder(
          shrinkWrap: true,
          itemCount: itemsList.length,
          itemBuilder: ((context, index) {
            final driver = itemsList[index];
            final carDetails = driver["car_details"] ?? {};
            final carSeats = carDetails["carSeats"] ?? "";
            final carModel = carDetails["carModel"] ?? "";
            final carNumber = carDetails["carNumber"] ?? "";
            final driverPhotoUrl = driver["photo"]?.toString() ?? "";

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                cMethods.data(2, Text(driver["id"]?.toString() ?? "N/A", style: const TextStyle(color: Colors.white)),),
                cMethods.data(1,
                  Image(
                    image: NetworkImage(
                      driverPhotoUrl,
                      scale: 1.0,
                    ),
                    width: 50,
                    height: 50,
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                      return GestureDetector(
                        onTap: () {
                          if (driverPhotoUrl.isNotEmpty) {
                            launch(driverPhotoUrl);
                          }
                        },
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.amber,
                          child: Image.asset("assets/images/drivericon.png", height: 30, width: 30)),
                      );
                    },
                  ),
                ),
                cMethods.data(1, Text(driver["name"]?.toString() ?? "N/A", style: const TextStyle(color: Colors.white)),),
                cMethods.data(1, Text("$carSeats - $carModel - $carNumber", style: const TextStyle(color: Colors.white)),),
                cMethods.data(1, Text(driver["phone"]?.toString() ?? "N/A", style: const TextStyle(color: Colors.white)),),
                cMethods.data(1, driver["earnings"] != null ? Text("₹ ${driver["earnings"]}", style: const TextStyle(color: Colors.white)) : const Text("₹ 0", style: TextStyle(color: Colors.white)),),
                cMethods.data(1, driver["blockStatus"] == "no" ? 
                  MaterialButton(
                    minWidth: 20,
                    height: 25,
                    color: const Color.fromARGB(255, 4, 33, 76),
                    onPressed: () async {
                      await FirebaseDatabase.instance
                          .ref()
                          .child("drivers")
                          .child(driver["id"])
                          .update({
                        "blockStatus": "Yes",
                      });
                    },
                    child: const Text(
                      "Block",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ) : MaterialButton(
                    minWidth: 20,
                    height: 25,
                    color: const Color.fromARGB(255, 4, 33, 76),
                    onPressed: () async {
                      await FirebaseDatabase.instance
                          .ref()
                          .child("drivers")
                          .child(driver["id"])
                          .update({
                        "blockStatus": "no",
                      });
                    },
                    child: const Text("Approve", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }
}
