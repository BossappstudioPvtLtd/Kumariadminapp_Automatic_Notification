import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kumari_admin_web/common_methods.dart';

class DriversDataList extends StatefulWidget {
  const DriversDataList({super.key});

  @override
  State<DriversDataList> createState() => _DriversDataListState();
}

class _DriversDataListState extends State<DriversDataList> {
  final driversRecordsFromDatabase =
      FirebaseDatabase.instance.ref().child("drivers");
  CommonMethods cMethods = CommonMethods();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: driversRecordsFromDatabase.onValue,
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
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                cMethods.data(
                  2,
                  Text(itemsList[index]["id"].toString()),
                ),
                cMethods.data(
                  1,
                  Image.network(
                    itemsList[index]["photo"].toString(),
                    width: 50,
                    height: 50,
                  ),
                ),
                cMethods.data(
                  1,
                  Text(itemsList[index]["name"].toString()),
                ),
                cMethods.data(
                  1,
                  Text(
                    "${itemsList[index]["car_details"]["carModel"]} - ${itemsList[index]["car_details"]["carNumber"]}",
                  ),
                ),
                cMethods.data(
                  1,
                  Text(itemsList[index]["phone"].toString()),
                ),
                cMethods.data(
                  1,
                  itemsList[index]["earnings"] != null
                      ? Text("\$ ${itemsList[index]["earnings"]}")
                      : const Text("\$ 0"),
                ),
                cMethods.data(
                  1,
                  itemsList[index]["blockStatus"] == "no"
                      ? MaterialButton(
                          color: const Color.fromARGB(255, 4, 33, 76),
                          onPressed: () async {
                            await FirebaseDatabase.instance
                                .ref()
                                .child("drivers")
                                .child(itemsList[index]["id"])
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
                        )
                      : ElevatedButton(
                          onPressed: ()async {
                             await FirebaseDatabase.instance
                                .ref()
                                .child("drivers")
                                .child(itemsList[index]["id"])
                                .update({
                              "blockStatus": "no",
                            });
                          },
                          child: const Text(
                            "Approve",
                            style: TextStyle(
                              color: Color.fromARGB(255, 4, 33, 76),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
