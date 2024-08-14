import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class FarePage extends StatefulWidget {
  static const String id = "webPageFare";
  const FarePage({super.key});

  @override
  State<FarePage> createState() => _FarePageState();
}

class _FarePageState extends State<FarePage> {
  bool _isEditing = false;
  final fareData = [
    {'category': 'Autorickshaw', 'vehicle Fare': '₹50', 'kmFare': '₹5/km', 'Minutes Fare': '₹10', 'taxAmount (Gst)': '%5'},
    {'category': 'XUVS', 'vehicle Fare': '₹100', 'kmFare': '₹10/km', 'Minutes Fare': '₹20', 'taxAmount (Gst)': '%10'},
    {'category': 'premium', 'vehicle Fare': '₹150', 'kmFare': '₹15/km', 'Minutes Fare': '₹30', 'taxAmount (Gst)': '%15'},
  ];
  final distanceData = [
    {'range': '0-5 km', 'surcharge': '₹0'},
    {'range': '5-10 km', 'surcharge': '₹50'},
    {'range': '10-20 km', 'surcharge': '₹100'},
  ];
  final controllers = <List<TextEditingController>>[];
  final distanceControllers = <List<TextEditingController>>[];
  final double _radiusLimit = 100000.0; // Admin-defined radius limit

  double _currentRadius = 1000.0;
  double _currentSurcharge = 0.0;

  @override
  void initState() {
    super.initState();
    for (var fare in fareData) {
      controllers.add(fare.values.map((value) => TextEditingController(text: value)).toList());
    }
    for (var distance in distanceData) {
      distanceControllers.add(distance.values.map((value) => TextEditingController(text: value)).toList());
    }
    _updateSurcharge();
  }

  @override
  void dispose() {
    for (var controllerList in controllers) {
      for (var controller in controllerList) {
        controller.dispose();
      }
    }
    for (var controllerList in distanceControllers) {
      for (var controller in controllerList) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void _toggleEditing() => setState(() => _isEditing = !_isEditing);

  void _saveChanges() async {
    // Simulate saving data
    print('Saving fare data: $fareData');
    print('Saving distance data: $distanceData');
    _toggleEditing();
  }

  void _updateFare(int index) {
    setState(() {
      final radiusMultiplier = _currentRadius > _radiusLimit ? 1.5 : 1.0; // Increase fare by 50% if radius exceeds limit
      fareData[index] = {
        'category': controllers[index][0].text,
        'vehicle Fare': '₹${(double.parse(controllers[index][1].text.substring(1)) * radiusMultiplier).toStringAsFixed(2)}',
        'kmFare': '₹${(double.parse(controllers[index][2].text.substring(1, controllers[index][2].text.length - 3)) * radiusMultiplier).toStringAsFixed(2)}/km',
        'Minutes Fare': '₹${(double.parse(controllers[index][3].text.substring(1)) * radiusMultiplier).toStringAsFixed(2)}',
        'taxAmount (Gst)': controllers[index][4].text,
      };
    });
  }

  void _updateDistanceData(int index) {
    setState(() {
      distanceData[index] = {
        'range': distanceControllers[index][0].text,
        'surcharge': distanceControllers[index][1].text,
      };
      _updateSurcharge(); // Ensure surcharge is updated based on new data
    });
  }

  void _updateSurcharge() {
    double surcharge = 0.0;
    for (var data in distanceData) {
      final range = data['range']!;
      final surchargeStr = data['surcharge']!;
      if (range.contains('0-5') && _currentRadius <= 5 * 1000) {
        surcharge = double.parse(surchargeStr.substring(1));
      } else if (range.contains('5-10') && _currentRadius > 5 * 1000 && _currentRadius <= 10 * 1000) {
        surcharge = double.parse(surchargeStr.substring(1));
      } else if (range.contains('10-20') && _currentRadius > 10 * 1000 && _currentRadius <= 20 * 1000) {
        surcharge = double.parse(surchargeStr.substring(1));
      }
    }
    setState(() {
      _currentSurcharge = surcharge;
      // Update surcharge values in distanceData to reflect changes dynamically
      for (var data in distanceData) {
        final range = data['range']!;
        if (range.contains('0-5') && _currentRadius <= 5 * 1000) {
          data['surcharge'] = '₹${surcharge.toStringAsFixed(2)}';
        } else if (range.contains('5-10') && _currentRadius > 5 * 1000 && _currentRadius <= 10 * 1000) {
          data['surcharge'] = '₹${surcharge.toStringAsFixed(2)}';
        } else if (range.contains('10-20') && _currentRadius > 10 * 1000 && _currentRadius <= 20 * 1000) {
          data['surcharge'] = '₹${surcharge.toStringAsFixed(2)}';
        }
      }
    });
  }

  void _updateRadius(double value) {
    setState(() {
      _currentRadius = value * _radiusLimit;
      _updateSurcharge();
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
            colors: [Color.fromARGB(255, 4, 33, 76), Color.fromARGB(255, 6, 79, 188)],
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
                    _buildTableHeader(),
                    const SizedBox(height: 10),
                    _buildFareTable(),
                    const SizedBox(height: 50),
                    Text("Distance surcharge", style: TextStyle(color: Colors.white, fontSize: 30)),
                    const SizedBox(height: 20),
                    _buildDistanceTable(),
                    const SizedBox(height: 20),
                    _buildRadiusSection(),
                    const SizedBox(height: 20),
                    _buildActionButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Container(height: 4000,),
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
            for (int i = 0; i < 3; i++)
              ScaleAnimatedText(
                'Manage Fare',
                textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color.fromARGB(255, 12, 59, 131), Color.fromARGB(255, 4, 33, 76)],
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("Category", style: TextStyle(color: Colors.white)),
          Text("Vehicle Fare", style: TextStyle(color: Colors.white)),
          Text("Kilometer Fare", style: TextStyle(color: Colors.white)),
          Text("Minutes Fare", style: TextStyle(color: Colors.white)),
          Text("Tax Amount (Gst)", style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildFareTable() {
    return Table(
      border: TableBorder.all(color: Colors.black),
      children: [
        for (int i = 0; i < fareData.length; i++) _buildFareTableRow(i),
      ],
    );
  }

  TableRow _buildFareTableRow(int index) {
    return TableRow(
      children: [
        _buildFareTableCell(index, 0),
        _buildFareTableCell(index, 1),
        _buildFareTableCell(index, 2),
        _buildFareTableCell(index, 3),
        _buildFareTableCell(index, 4),
      ],
    );
  }

  Widget _buildFareTableCell(int index, int column) {
    final isEditing = _isEditing;
    return Container(
      alignment: Alignment.center,
      height: 40,
      child: isEditing
          ? TextField(
              controller: controllers[index][column],
              onChanged: (_) => _updateFare(index),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
            )
          : Text(fareData[index].values.elementAt(column),style: TextStyle(color: Colors.white),),
    );
  }

  Widget _buildDistanceTable() {
    return Table(
      border: TableBorder.all(color: Colors.black),
      children: [
        for (int i = 0; i < distanceData.length; i++) _buildDistanceTableRow(i),
      ],
    );
  }

  TableRow _buildDistanceTableRow(int index) {
    return TableRow(
      children: [
        _buildDistanceTableCell(index, 0),
        _buildDistanceTableCell(index, 1),
      ],
    );
  }

  Widget _buildDistanceTableCell(int index, int column) {
    final isEditing = _isEditing;
    return Container(
      alignment: Alignment.center,
      height: 40,
      child: isEditing
          ? TextField(
              controller: distanceControllers[index][column],
              
                
              onChanged: (_) => _updateDistanceData(index),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
            )
          : Text(distanceData[index].values.elementAt(column),style: TextStyle(color: Colors.white),),
    );
  }

  Widget _buildRadiusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Set Distance Radius", style: TextStyle(color: Colors.white, fontSize: 20)),
        Slider(
          value: _currentRadius / _radiusLimit,
          onChanged: _updateRadius,
          min: 0,
          max: 1,
          divisions: 10,
          label: "${(_currentRadius / 1000).toStringAsFixed(0)} km",
        ),
        Text("Current Radius: ${(_currentRadius / 1000).toStringAsFixed(0)} km", style: TextStyle(color: Colors.white)),
        Text("Current Surcharge: ₹${_currentSurcharge.toStringAsFixed(2)}", style: TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildActionButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _isEditing ? _saveChanges : _toggleEditing,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isEditing ? Colors.green : Colors.white,
        ),
        child: Text(_isEditing ? "Save Changes" : "Edit",style: TextStyle(color: Colors.black),),
      ),
    );
  }
}
