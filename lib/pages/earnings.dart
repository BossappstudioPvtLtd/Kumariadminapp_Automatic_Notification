import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kumari_admin_web/Com/common_methods.dart';
import 'package:kumari_admin_web/data_fatching/earingsdata.dart';

class EarningsPage extends StatefulWidget {
  static const String id = "webEarningsPage";

  const EarningsPage({super.key});

  @override
  State<EarningsPage> createState() => _EarningsPageState();
}

class _EarningsPageState extends State<EarningsPage> {
  
  CommonMethods cMethods = CommonMethods();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  String? _currentCommission;
  String? _formattedDate;
  String? _formattedTime;
  final TextEditingController _commissionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _readCommissionData();
  }

  void _readCommissionData() {
    _database.child('commissions').onValue.listen((DatabaseEvent event) {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        setState(() {
          _currentCommission = data['commissionPercentage'].toString();

          final timestamp = data['timestamp'] as int?;
          if (timestamp != null) {
            final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
            _formattedDate =
                "${dateTime.year}-${dateTime.month}-${dateTime.day}";
            _formattedTime =
                "${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
          } else {
            _formattedDate = null;
            _formattedTime = null;
          }
        });
      } else {
        setState(() {
          _currentCommission = null;
          _formattedDate = null;
          _formattedTime = null;
        });
      }
    });
  }

  void _createOrUpdateCommission(String commissionPercentage) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    _database.child('commissions').set({
      'commissionPercentage': commissionPercentage,
      'timestamp': timestamp,
    }).then((_) {
      // Handle success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Commission updated successfully')),
      );
      _commissionController.clear();
    }).catchError((error) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update commission: $error')),
      );
    });
  }

  void _deleteCommission() {
    _database.child('commissions').remove().then((_) {
      setState(() {
        _currentCommission = null;
        _formattedDate = null;
        _formattedTime = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Commission deleted successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete commission: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        
                  height: 40000,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color.fromARGB(255, 4, 33, 76),
              Color.fromARGB(255, 6, 79, 188),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      ScaleAnimatedText(
                        'Manage Earnings',
                        textStyle: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  color: Colors.white.withOpacity(0.9),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentCommission != null
                              ? 'Current Commission: $_currentCommission%'
                              : 'No commission data available',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _formattedDate != null
                              ? 'Last Updated Date: $_formattedDate'
                              : 'No date available',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _formattedTime != null
                              ? 'Last Updated Time: $_formattedTime'
                              : 'No time available',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _commissionController,
                          decoration: InputDecoration(
                            labelText: 'New Commission Percentage',
                            labelStyle: const TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                if (_commissionController.text.isNotEmpty) {
                                  _createOrUpdateCommission(
                                      _commissionController.text);
                                }
                              },
                              icon: const Icon(Icons.save),
                              label: const Text('Save'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _deleteCommission,
                              icon: const Icon(Icons.delete),
                              label: const Text('Delete'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric( vertical: 15, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                Row(
                  children: [
                    cMethods.header(2, "DRIVER ID"),
                    cMethods.header(1, "NAME"),
                    cMethods.header(1, "PHONE"),
                    cMethods.header(1, "TOTAL EARNINGS"),
                    cMethods.header(1, "ACTION"),
                  ],
                ),
               Earingsdata(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
