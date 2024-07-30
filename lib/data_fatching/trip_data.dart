import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kumari_admin_web/common_methods.dart';
import 'package:url_launcher/url_launcher.dart';

class TripsDataList extends StatefulWidget {
  const TripsDataList({super.key});

  @override
  State<TripsDataList> createState() => _TripsDataListState();
}

class _TripsDataListState extends State<TripsDataList> {
  final completedTripsRecordsFromDatabase =
      FirebaseDatabase.instance.ref().child("tripRequests");
  CommonMethods cMethods = CommonMethods();

  launchGoogleMapFromSourceToDestination(
    pickUpLat,
    pickUpLng,
    dropOffLat,
    dropOffLng,
  ) async {
    String directionAPIUrl =
        "https://www.google.com/maps/dir/?api=1&origin=$pickUpLat,$pickUpLng&destination=$dropOffLat,$dropOffLng&dir_action=navigate";

    if (await canLaunchUrl(Uri.parse(directionAPIUrl))) {
      await launchUrl(Uri.parse(directionAPIUrl));
    } else {
      throw "Could not lauch google map";
    }
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
                  cMethods.data(2,Text(itemsList[index]["tripID"].toString(),style: const TextStyle(color: Colors.white),),),
                  cMethods.data( 1,Text(itemsList[index]["userName"].toString(),style: const TextStyle(color: Colors.white),),),
                  cMethods.data( 1,Text(itemsList[index]["driverName"].toString(),style: const TextStyle(color: Colors.white),),),
                  cMethods.data(1,Text(itemsList[index]["carDetails"].toString(),style: const TextStyle(color: Colors.white),),),
                  cMethods.data(1,Text(itemsList[index]["publishDateTime"].toString(),style: const TextStyle(color: Colors.white),),),
                  cMethods.data( 1,Text("₹ ${itemsList[index]["fareAmount"]}",style: const TextStyle(color: Colors.white),),),
                  cMethods.data( 1,


                  MaterialButton(
                    color: const Color.fromARGB(255, 4, 33, 76),
                  splashColor: Colors.grey,
                  onPressed: () {
                    
                        String pickUpLat  = itemsList[index]["pickUpLatLng"]["latitude"];
                        String pickUpLng  = itemsList[index]["pickUpLatLng"]["longitude"];
                        String dropOffLat = itemsList[index]["dropOffLatLng"]["latitude"];
                        String dropOffLng = itemsList[index]["dropOffLatLng"]["longitude"];

                  launchGoogleMapFromSourceToDestination(pickUpLat, pickUpLng,dropOffLat,dropOffLng,);},
                  child: const Text( "View More", style: TextStyle( color: Colors.white, fontWeight: FontWeight.bold,), ),
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
