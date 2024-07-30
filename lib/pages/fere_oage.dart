import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:kumari_admin_web/common_methods.dart';

class FarePage extends StatefulWidget {
  static const String id = "webPageFare";
  const FarePage({super.key});

  @override
  State<FarePage> createState() => _FarePageState();
}

CommonMethods cMethods = CommonMethods();

class _FarePageState extends State<FarePage> {
  bool _isEditing = false;
  List<Map<String, String>> fareData = [
    {
      'category': 'Autorickshaw',
      'vehicle Fare': '₹50',
      'kmFare': '₹5/km',
      'Minutes Fare': '₹10',
      'taxAmount (Gst)': '%5'
    },
    {
      'category': 'XUVS',
      'vehicle Fare': '₹100',
      'kmFare': '₹10/km',
      'Minutes Fare': '₹20',
      'taxAmount (Gst)': '%10'
    },
    {
      'category': 'premium',
      'vehicle Fare': '₹150',
      'kmFare': '₹15/km',
      'Minutes Fare': '₹30',
      'taxAmount (Gst)': '%15'
    },
  ];

  // Controllers for each editable cell
  List<List<TextEditingController>> controllers = [];

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    for (var fare in fareData) {
      controllers.add([
        TextEditingController(text: fare['category']),
        TextEditingController(text: fare['vehicle Fare']),
        TextEditingController(text: fare['kmFare']),
        TextEditingController(text: fare['Minutes Fare']),
        TextEditingController(text: fare['taxAmount (Gst)']),
      ]);
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    for (var controllerList in controllers) {
      for (var controller in controllerList) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() async {
    // Implement your logic to save changes to the backend here.
    // Example: await cMethods.uploadFareData(fareData);

    // For now, just print the data to the console.
    print('Saving data: $fareData');

    // Toggle back to view mode
    _toggleEditing();
  }

  void _updateFare(int index, String category, String vehicleFare,
      String kmFare, String minFare, String taxAmount) {
    setState(() {
      fareData[index] = {
        'category': category,
        'vehicle Fare': vehicleFare,
        'kmFare': kmFare,
        'Minutes Fare': minFare,
        'taxAmount (Gst)': taxAmount,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  height: 30,
                  alignment: Alignment.topLeft,
                  child: AnimatedTextKit(
                    totalRepeatCount: DateTime.monthsPerYear,
                    animatedTexts: [
                      ScaleAnimatedText(
                        'Manage Fare',
                        textStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      ScaleAnimatedText(
                        'Manage Fare',
                        textStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      ScaleAnimatedText(
                        'Manage Fare',
                        textStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(255, 12, 59, 131),
                            Color.fromARGB(255, 4, 33, 76),
                          ],
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Category",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "Vehicle Fare",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "  kilometer Fare",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "  Minutes Fare",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "Tax Amount (Gst)",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Table(
                      border: TableBorder.all(color: Colors.black),
                      children: [
                        for (int i = 0; i < fareData.length; i++)
                          _buildTableRow(
                            i,
                            fareData[i]['category']!,
                            fareData[i]['vehicle Fare']!,
                            fareData[i]['kmFare']!,
                            fareData[i]['Minutes Fare']!,
                            fareData[i]['taxAmount (Gst)']!,
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                        height: 40,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromARGB(255, 12, 59, 131),
                              Color.fromARGB(255, 4, 33, 76),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 600),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(_isEditing ? Icons.save : Icons.edit,
                                    color: Colors.white),
                                onPressed:
                                    _isEditing ? _saveChanges : _toggleEditing,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (_isEditing) {
                                    _saveChanges();
                                  } else {
                                    _toggleEditing();
                                  }
                                },
                                child: Text(
                                  _isEditing ? "Save" : "Edit",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        )),
                        Container(height: 4000,)
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(int index, String category, String vehicleFare,
      String kmFare, String minFare, String taxAmount) {
    return TableRow(
      children: [
        _isEditing
            ? _buildEditableCell(index, 0, category)
            : _buildTableCell(category),
        _isEditing
            ? _buildEditableCell(index, 1, vehicleFare)
            : _buildTableCell(vehicleFare),
        _isEditing
            ? _buildEditableCell(index, 2, kmFare)
            : _buildTableCell(kmFare),
        _isEditing
            ? _buildEditableCell(index, 3, minFare)
            : _buildTableCell(minFare),
        _isEditing
            ? _buildEditableCell(index, 4, taxAmount)
            : _buildTableCell(taxAmount),
      ],
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildEditableCell(int rowIndex, int colIndex, String initialValue) {
    var controller = controllers[rowIndex][colIndex];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.transparent,
        ),
        onChanged: (value) {
          _updateFare(
            rowIndex,
            colIndex == 0 ? value : fareData[rowIndex]['category']!,
            colIndex == 1 ? value : fareData[rowIndex]['vehicle Fare']!,
            colIndex == 2 ? value : fareData[rowIndex]['kmFare']!,
            colIndex == 3 ? value : fareData[rowIndex]['MinutesFare']!,
            colIndex == 4 ? value : fareData[rowIndex]['taxAmount (Gst)']!,
          );
        },
      ),
    );
  }
}
