import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kumari_admin_web/data_fatching/earingsdata.dart';

class EarningsPage extends StatefulWidget {
  static const String id = "webEarningsPage";

  const EarningsPage({super.key});

  @override
  State<EarningsPage> createState() => _EarningsPageState();
}

class _EarningsPageState extends State<EarningsPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final TextEditingController _commissionController = TextEditingController();

  String? _currentCommission, _formattedDate, _formattedTime;
  List<Map<String, dynamic>> _commissionHistory = [];
  final int _daysThreshold = 30; // Define threshold for "old" dates

  @override
  void initState() {
    super.initState();
    _readCommissionData();
    _fetchCommissionHistory();
  }

  void _readCommissionData() {
    _database.child('commissions/current').onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          _currentCommission = data['commissionPercentage']?.toString();
          final timestamp = data['timestamp'] as int?;
          if (timestamp != null) {
            final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
            _formattedDate = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
            _formattedTime = "${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
          }
        });
      } else {
        setState(() {
          _currentCommission = _formattedDate = _formattedTime = null;
        });
      }
    });
  }

  void _fetchCommissionHistory() {
    _database.child('commissions/history').onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        List<Map<String, dynamic>> history = [];
        data.forEach((key, value) {
          final commission = value as Map<dynamic, dynamic>;
          history.add({
            'commissionPercentage': commission['commissionPercentage']?.toString(),
            'timestamp': commission['timestamp'] as int?,
          });
        });

        // Sort the history list by timestamp in descending order
        history.sort((a, b) {
          final timestampA = a['timestamp'] as int?;
          final timestampB = b['timestamp'] as int?;
          if (timestampA == null && timestampB == null) return 0;
          if (timestampA == null) return 1; // Null values go to the end
          if (timestampB == null) return -1; // Null values go to the end
          return timestampB.compareTo(timestampA); // Descending order
        });

        setState(() {
          _commissionHistory = history;
        });
      }
    });
  }

  void _createOrUpdateCommission(String commissionPercentage) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _database.child('commissions/current').set({
      'commissionPercentage': commissionPercentage,
      'timestamp': timestamp,
    }).then((_) {
      // Save to history
      _database.child('commissions/history').push().set({
        'commissionPercentage': commissionPercentage,
        'timestamp': timestamp,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Commission updated successfully')));
      _commissionController.clear();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update commission: $error')));
    });
  }

  void _deleteCommission() {
    _database.child('commissions/current').remove().then((_) {
      setState(() {
        _currentCommission = _formattedDate = _formattedTime = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Commission deleted successfully')));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete commission: $error')));
    });
  }

  bool _isOldDate(DateTime dateTime) {
    final now = DateTime.now();
    final thresholdDate = now.subtract(Duration(days: _daysThreshold));
    return dateTime.isBefore(thresholdDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF043754), Color(0xFF064FBC)],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
                child: AnimatedTextKit(
                  animatedTexts: [
                    ScaleAnimatedText(
                      'Manage Earnings',
                      textStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Card(
                color: Colors.black12,
                elevation: 20,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                     gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: const [
                Color.fromARGB(255, 12, 59, 131),
                Color.fromARGB(255, 4, 33, 76),
              ],
            ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentCommission != null
                              ? 'Current Commission: $_currentCommission%'
                              : 'No commission data available',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                        SizedBox(height: 10),
                        Text(
                          _formattedDate != null
                              ? 'Last Updated Date: $_formattedDate'
                              : 'No date available',
                          style: TextStyle(fontSize: 16, color: Colors.white54),
                        ),
                        SizedBox(height: 5),
                        Text(
                          _formattedTime != null
                              ? 'Last Updated Time: $_formattedTime'
                              : 'No time available',
                          style: TextStyle(fontSize: 16, color: Colors.white54),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _commissionController,
                          decoration: InputDecoration(
                            labelText: 'New Commission Percentage',
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                final text = _commissionController.text;
                                if (text.isNotEmpty) {
                                  _createOrUpdateCommission(text);
                                }
                              },
                              icon: Icon(Icons.save),
                              label: Text('Save'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _deleteCommission,
                              icon: Icon(Icons.delete),
                              label: Text('Delete'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Commission History',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 10),
              ..._commissionHistory.map((entry) {
                final dateTime = DateTime.fromMillisecondsSinceEpoch(entry['timestamp'] as int);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                     gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: const <Color>[
                Color.fromARGB(255, 4, 33, 76),
                
                Color.fromARGB(255, 4, 33, 76),
              ])
            
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Row(
                            children: [
                              Text('Commission:', style: TextStyle(color: Colors.blue)),
                              Text("${entry['commissionPercentage']}%", style: TextStyle(color: Colors.redAccent)),
                            ],
                          ),
                          subtitle: Text(
                            'Date: ${dateTime.year}-${dateTime.month}-${dateTime.day} Time: ${dateTime.hour}:${dateTime.minute}:${dateTime.second}',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                        // Replace CombinedDataPage with your widget or remove it if not needed
                        CombinedDataPage(),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
