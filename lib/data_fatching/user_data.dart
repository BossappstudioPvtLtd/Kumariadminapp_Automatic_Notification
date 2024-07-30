import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kumari_admin_web/common_methods.dart';

class UsersDataList extends StatefulWidget {
  const UsersDataList({super.key});

  @override
  State<UsersDataList> createState() => _UsersDataListState();
}

class _UsersDataListState extends State<UsersDataList> {
  final usersRecordsFromDatabase =
      FirebaseDatabase.instance.ref().child("users");
  final CommonMethods cMethods = CommonMethods();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                  Text(itemsList[index]["id"].toString(),style: const TextStyle(color: Colors.white),),
                ),
                cMethods.data(
                  1,
                  Text(itemsList[index]["name"].toString(),style: const TextStyle(color: Colors.white),),
                ),
                cMethods.data(
                  1,
                  Text(itemsList[index]["email"].toString(),style: const TextStyle(color: Colors.white),),
                ),
                cMethods.data(
                  1,
                  Text(itemsList[index]["phone"].toString(),style: const TextStyle(color: Colors.white),),
                ),
                cMethods.data(
                  1,
                  itemsList[index]["blockStatus"] == "no"
                      ? MaterialButton(
                        minWidth: 20,
                        height: 25,
                          color: const Color.fromARGB(255, 4, 33, 76),
                          onPressed: () async {
                            await FirebaseDatabase.instance
                                .ref()
                                .child("users")
                                .child(itemsList[index]["id"])
                                .update({
                              "blockStatus": "yes",
                            });
                            _checkAndLogout(itemsList[index]["id"]);
                          },
                          child: const Text(
                            "Block",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : MaterialButton(
                        
                        minWidth: 20,
                        height: 25,
                        
                          color: const Color.fromARGB(255, 4, 33, 76),
                          onPressed: () async {
                            await FirebaseDatabase.instance
                                .ref()
                                .child("users")
                                .child(itemsList[index]["id"])
                                .update({
                              "blockStatus": "no",
                            });
                          },
                          child: const Text(
                            "Approve",
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

  Future<void> _checkAndLogout(String userId) async {
    // Get the current user
    User? user = _auth.currentUser;
    if (user != null && user.uid == userId) {
      // If the current user's ID matches the blocked user's ID, log them out
      await _auth.signOut();
    }
  }
}
