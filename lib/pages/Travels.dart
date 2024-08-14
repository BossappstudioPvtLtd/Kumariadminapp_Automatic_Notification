import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html;

class TravelDataEntryPage extends StatefulWidget {
  const TravelDataEntryPage({super.key});

  @override
  _TravelDataEntryPageState createState() => _TravelDataEntryPageState();
}

class _TravelDataEntryPageState extends State<TravelDataEntryPage> {
  
  final _formKey = GlobalKey<FormState>();
  final _database = FirebaseDatabase.instance.ref();
  late String vehicleDetails, phoneNumber, travelName, vehicleColor, vehicleModel, photoUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Data Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Vehicle Details'),
                onSaved: (value) {
                  vehicleDetails = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter vehicle details';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                onSaved: (value) {
                  phoneNumber = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Travel Name'),
                onSaved: (value) {
                  travelName = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a travel name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Vehicle Color'),
                onSaved: (value) {
                  vehicleColor = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter vehicle color';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Vehicle Model'),
                onSaved: (value) {
                  vehicleModel = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter vehicle model';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Upload Photo'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTravelData,
                child: const Text('Save Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      if (files!.isNotEmpty) {
        final reader = html.FileReader();
        reader.readAsDataUrl(files[0]);
        reader.onLoadEnd.listen((event) {
          setState(() {
            photoUrl = reader.result as String; // Set the photo URL
          });
        });
      }
    });
  }

  void _saveTravelData() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newTravelData = TravelData(
        vehicleDetails: vehicleDetails,
        phoneNumber: phoneNumber,
        travelName: travelName,
        vehicleColor: vehicleColor,
        vehicleModel: vehicleModel,
        photoUrl: photoUrl,
      );

      _database.child('travels').push().set(newTravelData.toJson()).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data saved successfully!')));
      });
    }
  }
}

class TravelData {
  String vehicleDetails;
  String phoneNumber;
  String travelName;
  String vehicleColor;
  String vehicleModel;
  String photoUrl;

  TravelData({
    required this.vehicleDetails,
    required this.phoneNumber,
    required this.travelName,
    required this.vehicleColor,
    required this.vehicleModel,
    required this.photoUrl,
  });

  Map<String, dynamic> toJson() => {
    'vehicleDetails': vehicleDetails,
    'phoneNumber': phoneNumber,
    'travelName': travelName,
    'vehicleColor': vehicleColor,
    'vehicleModel': vehicleModel,
    'photoUrl': photoUrl,
  };
}
