import 'dart:html' as html;
import 'dart:typed_data';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:kumari_admin_web/Com/m_button.dart';
import 'package:url_launcher/url_launcher.dart';

class AdvertisementPage extends StatefulWidget {
  static const String id = "\"webPageAdvertisement";
  const AdvertisementPage({super.key});

  @override
  State<AdvertisementPage> createState() => _AdvertisementPageState();
}

class Advertisement {
  final String key;
  final String title;
  final String description;
  final String imageUrl;
  final String postDate;
  final String expiryDate;

  Advertisement({
    required this.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.postDate,
    required this.expiryDate,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json, String key) {
    return Advertisement(
      key: key,
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      postDate: json['postDate'] ?? '',
      expiryDate: json['expiryDate'] ?? '',
    );
  }
}

class _AdvertisementPageState extends State<AdvertisementPage> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('advertisements');
  List<Advertisement> _advertisements = [];
  html.File? _imageFile;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _fetchAdvertisements();
  }

  void _fetchAdvertisements() {
    _databaseReference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        final List<Advertisement> ads = [];
        data.forEach((key, value) {
          final ad =
              Advertisement.fromJson(Map<String, dynamic>.from(value), key);
          ads.add(ad);
        });
        setState(() {
          _advertisements = ads;
        });
        print('Advertisements fetched: $_advertisements');
        _advertisements.forEach((ad) => print('Image URL: ${ad.imageUrl}'));
      } else {
        setState(() {
          _advertisements = [];
        });
      }
    }).onError((error) {
      print('Error fetching data: $error');
    });
  }

  Future<void> _pickImage() async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();
    uploadInput.accept = 'image/*'; // Accept only image files

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files!.isEmpty) return;

      final file = files[0];
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      reader.onLoadEnd.listen((e) async {
        final bytes = reader.result as Uint8List;
        setState(() {
          _imageBytes = bytes;
          _imageFile = file;
        });
      });
    });

    uploadInput.click();
  }

  Future<String?> _uploadImage(html.File image) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialog(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: Colors.black,
                  ),
                  SizedBox(width: 20),
                  Text("Uploading Your Data..."),
                ],
              ),
            ),
          );
        },
      );

      final storageRef = FirebaseStorage.instance.ref().child('advertisement_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putBlob(image);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      Navigator.pop(context);

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      Navigator.pop(context);
      return null;
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      controller.text = dateFormat.format(selectedDate);
    }
  }

  Future<void> _updateAdvertisement(Advertisement ad) async {
    final TextEditingController titleController =
        TextEditingController(text: ad.title);
    final TextEditingController descriptionController =
        TextEditingController(text: ad.description);
    final TextEditingController postDateController =
        TextEditingController(text: ad.postDate);
    final TextEditingController expiryDateController =
        TextEditingController(text: ad.expiryDate);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Advertisement'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _selectDate(postDateController),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: postDateController,
                      decoration: const InputDecoration(
                        labelText: 'Post Date (yyyy-MM-dd)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _selectDate(expiryDateController),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: expiryDateController,
                      decoration: const InputDecoration(
                        labelText: 'Expiry Date (yyyy-MM-dd)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final String title = titleController.text;
                final String description = descriptionController.text;
                final String postDate = postDateController.text;
                final String expiryDate = expiryDateController.text;

                if (title.isNotEmpty && description.isNotEmpty) {
                  final updatedData = {
                    'title': title,
                    'description': description,
                    'postDate': postDate,
                    'expiryDate': expiryDate,
                  };
                  if (_imageFile != null) {
                    final imageUrl = await _uploadImage(_imageFile!);
                    if (imageUrl != null) {
                      updatedData['imageUrl'] = imageUrl;
                    }
                  }
                  await _databaseReference.child(ad.key).update(updatedData);
                  setState(() {
                    _imageFile = null;
                    _imageBytes = null;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Update'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAdvertisement(String key) async {
    await _databaseReference.child(key).remove();
  }

  Widget buildDatePicker(TextEditingController controller, String labelText) {
    return GestureDetector(
      onTap: () => _selectDate(controller),
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.white30,
            border: const OutlineInputBorder(),
          ),
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.datetime,
        ),
      ),
    );
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
          child: Padding(
            padding: const EdgeInsets.all(25),
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
                          'Manage Advertisements',
                          textStyle: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        ScaleAnimatedText(
                          'Manage Advertisements',
                          textStyle: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        ScaleAnimatedText(
                          'Manage Advertisements',
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
                const SizedBox(height: 20),
                _buildAdvertisementForm(),
                const SizedBox(height: 20),
                _buildAdvertisementGrid(),
                Container(
                  height: 4000,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdvertisementForm() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController postDateController = TextEditingController();
    final TextEditingController expiryDateController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                dashPattern: const [6, 3],
                color: Colors.grey,
                child: Center(
                  child: IconButton(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.camera_alt, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            if (_imageBytes != null)
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: MemoryImage(_imageBytes!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          "Add Your Advertisements",
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 30),
        TextField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: 'Title',
            labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            filled: true,
            fillColor: Colors.black.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                  color: Color.fromARGB(255, 10, 30, 63), width: 1),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: descriptionController,
          decoration: InputDecoration(
            labelText: 'Description',
            labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            filled: true,
            fillColor: Colors.black.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                  color: Color.fromARGB(255, 10, 30, 63), width: 1),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: buildDatePicker(postDateController, 'Post Date ')),
            const SizedBox(width: 10),
            Expanded(
                child: buildDatePicker(expiryDateController, 'Expiry Date ')),
          ],
        ),
        const SizedBox(height: 30),
        MaterialButtons(
          textcolor: Colors.white,
          borderRadius: BorderRadius.circular(8),
          elevationsize: 20,
          text: 'Send Advertisement',
          containerheight: 40,
          containerwidth: double.infinity,
          meterialColor: const Color.fromARGB(255, 7, 26, 55),
          onTap: () async {
            final String title = titleController.text;
            final String description = descriptionController.text;
            final String postDate = postDateController.text;
            final String expiryDate = expiryDateController.text;

            if (title.isNotEmpty &&
                description.isNotEmpty &&
                _imageFile != null) {
              final imageUrl = await _uploadImage(_imageFile!);
              if (imageUrl != null) {
                _databaseReference.push().set({
                  'title': title,
                  'description': description,
                  'imageUrl': imageUrl,
                  'postDate': postDate,
                  'expiryDate': expiryDate,
                });
                setState(() {
                  _imageFile = null;
                  _imageBytes = null;
                });
              }
            }
          },
        ),
      ],
    );
  }

  Widget _buildAdvertisementGrid() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns in the grid
        crossAxisSpacing: 8.0, // Horizontal spacing between items
        mainAxisSpacing: 8.0, // Vertical spacing between items
        childAspectRatio: 1.0, // Aspect ratio of the items
      ),
      itemCount: _advertisements.length,
      itemBuilder: (context, index) {
        final advertisement = _advertisements[index];
        
        final DateTime expiryDate =
            DateFormat('yyyy-MM-dd').parse(advertisement.expiryDate);
        final bool isExpired = DateTime.now().isAfter(expiryDate);

        return Card(
          color: Colors.white24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Image.network(
                      advertisement.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        print('Image load error: $error');
                        print('Error details: ${stackTrace.toString()}');
                        return GestureDetector(
                          onTap: () => _launchURL(advertisement.imageUrl),
                          child: Image.asset("assets/images/img.jpg"),
                        );
                      },
                    ),
                    
                    Center(child: GestureDetector(
                      onTap: ()=>_launchURL(advertisement.imageUrl),
                      child: const Text("Click here",style: TextStyle(color: Colors.white),))),
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Material(
                          color: Colors.white24,
                          elevation: 20,
                          borderRadius: BorderRadius.circular(32),
                          child: IconButton(
                            hoverColor: const Color.fromARGB(255, 10, 30, 63),
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed: () => _updateAdvertisement(advertisement),
                          ),
                        ),
                        const SizedBox(
                          width: BorderSide.strokeAlignCenter,
                        ),
                        Material(
                          
                          color: Colors.white24,
                          elevation: 20,
                          
                          borderRadius: BorderRadius.circular(32),
                          child: IconButton(
                            hoverColor:  const Color.fromARGB(255, 10, 30, 63),
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _deleteAdvertisement(advertisement.key),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Title: ${advertisement.title}",
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Description: ${advertisement.description}",
                  style: const TextStyle(color: Colors.white70),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Posted on: ${advertisement.postDate}',
                      style: const TextStyle(color: Colors.green),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                  isExpired
                      ? Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AnimatedTextKit(
                              totalRepeatCount: 100,
                              animatedTexts: [
                                ColorizeAnimatedText(
                                  'Expired',
                                  textStyle: const TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  colors: [
                                    Colors.red,
                                    Colors.red,
                                    Colors.white,
                                    Colors.orange,
                                    Colors.orange,
                                  ],
                                ),
                              ],
                              isRepeatingAnimation: true,
                            ),
                        ),
                      )
                      : Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'Expires on: ${DateFormat.yMMMd().format(expiryDate)}',
                              style: const TextStyle(
                                color: Colors.blue, // Blue for active
                              ),
                            ),
                        ),
                      ),
                
                ],
              ),
              const SizedBox(height: 20,)
            ],
          ),
        );
      },
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
