import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kumari_admin_web/Com/m_button.dart';
import 'package:kumari_admin_web/data_fatching/radius_data.dart';
import 'package:kumari_admin_web/data_fatching/fare_data.dart';

class FarePage extends StatefulWidget {
  static const String id = "webPageFare";
  const FarePage({super.key});

  @override
  State<FarePage> createState() => _FarePageState();
}

class _FarePageState extends State<FarePage> {
  bool _isEditing = false;

  final double _radiusLimit = 100.0; // Updated to limit value in kilometers
  double _currentAutorickshawRadius =
      0.0; // Updated to initial value in kilometers

  List<Map<String, dynamic>> radiusData = [
    {'category': 'Autorickshaw', 'radius': 0.0},
    {'category': 'SUVs', 'radius': 0.0},
    {'category': 'Premium', 'radius': 0.0},
  ];

  final DatabaseReference _radiusRef =
      FirebaseDatabase.instance.ref().child('radiusData');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _updateRadius(double value) {
    setState(() {
      _currentAutorickshawRadius = value * _radiusLimit;
    });
  }

  void _toggleEditing() => setState(() => _isEditing = !_isEditing);

  void _saveChanges() async {
    // Save radius data
    for (var data in radiusData) {
      await _radiusRef.child(data['category']).set(data);
    }

    _toggleEditing();
  }

  void _saveRadius(String category) 
  {
    
    setState(() {
      final index =
          radiusData.indexWhere((data) => data['category'] == category);
      if (index != -1) {
        radiusData[index] = {
          'category': category,
          'radius': _currentAutorickshawRadius,
        };
      }
    });
    // Update in Firebase
    _radiusRef
        .child(category)
        .set(radiusData.firstWhere((data) => data['category'] == category));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 4, 33, 76),
              Color.fromARGB(255, 6, 79, 188)
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    FareDataWebPanel(),
                    const Text(
                      "Radius surcharge",
                      style: TextStyle(color: Colors.white70, fontSize: 26),
                    ),
                    _buildRadiusTable(),
                    const SizedBox(height: 20),
                    _buildAutorickshawRadiusSection(),
                  ],
                ),
              ),
              Container(
                height: 4000,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Container(
        height: 30,
        alignment: Alignment.topLeft,
        child: AnimatedTextKit(
          totalRepeatCount: DateTime.monthsPerYear,
          animatedTexts: [
            ScaleAnimatedText(
              
              'Fare Management ',
              textStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
          isRepeatingAnimation: true,
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Row(
      children: [
        _buildTableCell('Radius (km)'),
      ],
    );
  }

  Widget _buildTableCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 4, 33, 76),
              Color.fromARGB(255, 6, 79, 188)
            ],
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTextField(String initialValue,
      {required int index, required int fieldIndex}) {
    return Expanded(
      flex: fieldIndex == 0 ? 2 : 1,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: _isEditing
            ? TextFormField(
                style: const TextStyle(color: Colors.white),
                initialValue: initialValue,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8.0),
                ),
              )
            : Text(
                initialValue,
                style: const TextStyle(color: Colors.white),
              ),
      ),
    );
  }

  Widget _buildRadiusTable() {
    return Column(
      children: [
        _buildTableHeader(),
        for (var data in radiusData)
          Row(
            children: [
              _buildTableCell(data['category']!),
              _buildTextField(data['radius'].toStringAsFixed(1),
                  index: radiusData.indexOf(data), fieldIndex: 1),
                  
            ],
          ),
         RadiusOffersPage(),
      ],
      
    );
  }

  Widget _buildAutorickshawRadiusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Radius',
          style: TextStyle(color: Colors.white70, fontSize: 20),
        ),
        Slider(
          value: _currentAutorickshawRadius / _radiusLimit,
          min: 0,
          max: 1,
          divisions: 50,
          onChanged: _updateRadius,
        ),
        Center(
          child: Text(
            'Radius: ${_currentAutorickshawRadius.toStringAsFixed(1)} km',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: MaterialButtons(
                meterialColor: const Color.fromARGB(255, 4, 33, 76),
                containerheight: 30,
                borderRadius: BorderRadius.circular(8),
                containerwidth: 120,
                textcolor: Colors.white,
                onTap: () => _saveRadius('Autorickshaw'),
                elevationsize: 20,
                text: 'Save Autorickshaw',
              ),
            ),
            SizedBox(width: 10,),
            Expanded(
              child: MaterialButtons(
                meterialColor: const Color.fromARGB(255, 4, 33, 76),
                containerheight: 30,
                borderRadius: BorderRadius.circular(8),
                containerwidth: 120,
                textcolor: Colors.white,
                onTap: () => _saveRadius('SUVs'),
                elevationsize: 20,
                text: 'Save SUVs',
              ),
            ),
            
            SizedBox(width: 10,),
            Expanded(
              child: MaterialButtons(
                meterialColor: const Color.fromARGB(255, 4, 33, 76),
                containerheight: 30,
                borderRadius: BorderRadius.circular(8),
                containerwidth: 120,
                textcolor: Colors.white,
                onTap: () => _saveRadius('Premium'),
                elevationsize: 20,
                text: 'Save Premium',
              ),
            ),
          ],
        ),
       
            
      ],
    );
  }
}
