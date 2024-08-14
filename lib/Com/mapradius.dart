import 'package:flutter/material.dart';

class MapRadiusExample extends StatefulWidget {
  const MapRadiusExample({super.key});

  @override
  _MapRadiusExampleState createState() => _MapRadiusExampleState();
}

class _MapRadiusExampleState extends State<MapRadiusExample> {
 
  double _currentRadius = 1000.0; // initial radius
  final double _radiusLimit = 100000.0; // Example radius limit

 

  void _updateRadius(double value) {
    setState(() {
      _currentRadius = value * _radiusLimit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
         
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Text('Radius: ${_currentRadius.toStringAsFixed(0)} meters'),
                Slider(
                  value: _currentRadius / _radiusLimit, // scale the value as needed
                  onChanged: _updateRadius,
                  min: 0,
                  max: 1,
                  divisions: 100,
                  label: '${(_currentRadius / 1000).toStringAsFixed(1)} km',
                ),
              ],
            ),
          ),
        ],
      
    );
  }
}
