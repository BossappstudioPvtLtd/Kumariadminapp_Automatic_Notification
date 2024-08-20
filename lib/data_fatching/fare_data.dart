import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FareDataWebPanel extends StatefulWidget {
  const FareDataWebPanel({super.key});

  @override
  _FareDataWebPanelState createState() => _FareDataWebPanelState();
}

class _FareDataWebPanelState extends State<FareDataWebPanel> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref('fareData');
  late Future<List<Map<String, dynamic>>> _fareDatasList;

  final _controllers = {
    'category': TextEditingController(),
    'Minutes Fare': TextEditingController(),
    'kmFare': TextEditingController(),
    'taxAmount (Gst)': TextEditingController(),
    'vehicle Fare': TextEditingController(),
  };
  final _formKey = GlobalKey<FormState>();
  String? _selectedKey;

  @override
  void initState() {
    super.initState();
    _fareDatasList = _fetchFareOffers();
  }

  Future<List<Map<String, dynamic>>> _fetchFareOffers() async {
    final event = await _database.once();
    final data = event.snapshot.value as Map<dynamic, dynamic>?;
    return data?.entries.map((entry) {
          final value = entry.value as Map<dynamic, dynamic>;
          return {
            'key': entry.key,
            'category': value['category'],
            'Minutes Fare': value['Minutes Fare'],
            'kmFare': value['kmFare'],
            'taxAmount (Gst)': value['taxAmount (Gst)'],
            'vehicle Fare': value['vehicle Fare'],
          };
        }).toList() ??
        [];
  }

  Future<void> _updateFareData() async {
    if (_formKey.currentState?.validate() ?? false) {
      await _database.child(_selectedKey!).update({
        'category': _controllers['category']!.text,
        'Minutes Fare': _controllers['Minutes Fare']!.text,
        'kmFare': _controllers['kmFare']!.text,
        'taxAmount (Gst)': _controllers['taxAmount (Gst)']!.text,
        'vehicle Fare': _controllers['vehicle Fare']!.text,
      });
      Navigator.of(context).pop();
      setState(() {
        _fareDatasList = _fetchFareOffers();
      });
    }
  }

  void _showForm({String? key}) async {
    if (key != null) {
      final snapshot = (await _database.child(key).once()).snapshot;
      final value = snapshot.value as Map<dynamic, dynamic>?;
      value?.forEach((k, v) {
        _controllers[k]!.text = v.toString();
      });
      _selectedKey = key;
    } else {
      _controllers.forEach((key, controller) => controller.clear());
    }
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 4, 33, 76),
        title: Text(
          key == null ? 'Add Fare Data' : 'Update Fare Data',
          style: const TextStyle(color: Colors.white),
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _controllers.keys
                .map((key) => TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: _controllers[key],
                      decoration: InputDecoration(
                          labelText: key,
                          labelStyle: const TextStyle(color: Colors.white70)),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter $key'
                          : null,
                    ))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              )),
          TextButton(
              onPressed: () => _updateFareData(),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Row(
      children: [
        'Category',
        'Vehicle Fare (₹)',
        'PER KM Fare (₹)',
        'Minutes Fare (₹)',
        'Tax Amount (%)',
        'Edit&Updation'
      ]
          .map((text) => Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 12, 59, 131),
                        Color.fromARGB(255, 4, 33, 76),
                      ],
                    ),
                    border: Border.all(
                      // Add a border to the container
                      color: Colors.black, // Color of the border
                      width: 1.0, // Border width
                    ),
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildFareTable(List<Map<String, dynamic>> fareData) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white10, // Border around the entire column
          width: 1.0, // Thickness of the column border
        ),
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          for (var fare in fareData)
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white10, // Border color between rows
                    width: 1.0, // Thickness of row borders
                  ),
                ),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(fare['category']!,
                          style: const TextStyle(color: Colors.white))),
                  Expanded(
                      child: Text(fare['vehicle Fare']!,
                          style: const TextStyle(color: Colors.white))),
                  Expanded(
                      child: Text(fare['kmFare']!,
                          style: const TextStyle(color: Colors.white))),
                  Expanded(
                      child: Text(fare['Minutes Fare']!,
                          style: const TextStyle(color: Colors.white))),
                  Expanded(
                      child: Text(fare['taxAmount (Gst)']!,
                          style: const TextStyle(color: Colors.white))),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () => _showForm(key: fare['key']),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fareDatasList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No fare offers available.'));
        }
        return SingleChildScrollView(child: _buildFareTable(snapshot.data!));
      },
    );
  }
}
