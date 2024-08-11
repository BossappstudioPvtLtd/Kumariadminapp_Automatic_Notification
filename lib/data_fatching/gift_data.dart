import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kumari_admin_web/common_methods.dart';
import 'package:kumari_admin_web/pages/gift_page.dart';

class GiftData extends StatefulWidget {
  final void Function(String userId) onGiftOfferSelected;

  const GiftData({super.key, required this.onGiftOfferSelected});

  @override
  State<GiftData> createState() => _GiftDataState();
}

class _GiftDataState extends State<GiftData> {
  final usersRecordsFromDatabase =
      FirebaseDatabase.instance.ref().child("users");
  final CommonMethods cMethods = CommonMethods();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: usersRecordsFromDatabase.onValue,
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
          scrollDirection: Axis.vertical,
          itemCount: itemsList.length,
          itemBuilder: ((context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                cMethods.data(
                  2,
                  Text(
                    itemsList[index]["id"].toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                cMethods.data(
                  1,
                  Text(
                    itemsList[index]["name"].toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                cMethods.data(
                  1,
                  Text(
                    itemsList[index]["email"].toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                cMethods.data(
                  1,
                  Text(
                    itemsList[index]["phone"].toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                cMethods.data(
                  1,
                  Text(
                    itemsList[index]["totalTripsCompleted"].toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                cMethods.data(
                  1,
                  MaterialButton(
                    minWidth: 20,
                    height: 25,
                    color: const Color.fromARGB(255, 4, 33, 76),
                    onPressed: () {
                      widget.onGiftOfferSelected(itemsList[index]["id"]);
                    },
                    child: const Text(
                      "Send Gift",
                      style: TextStyle(
                        color: Colors.white,
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
