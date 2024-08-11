import 'dart:html' as html;
import 'dart:typed_data';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:kumari_admin_web/Com/giftactivelist.dart';
import 'package:kumari_admin_web/Com/m_button.dart';
import 'package:kumari_admin_web/pages/gift_active.dart';
import 'package:url_launcher/url_launcher.dart';

class GiftPage extends StatefulWidget {
  static const String id = "webPageGift";
  const GiftPage({super.key});

  @override
  State<GiftPage> createState() => _GiftPageState();
}

class GiftOffer {
  final String key;
  final String title;
  final String description;
  final String imageUrl;
  final String postDate;
  final String expiryDate;

  GiftOffer({
    required this.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.postDate,
    required this.expiryDate,
  });

  factory GiftOffer.fromJson(Map<String, dynamic> json, String key) {
    return GiftOffer(
      key: key,
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      postDate: json['postDate'] ?? '',
      expiryDate: json['expiryDate'] ?? '',
    );
  }
}

class _GiftPageState extends State<GiftPage> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('giftOffers');
  List<GiftOffer> _giftOffers = [];
  html.File? _imageFile;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _fetchGiftOffers();
  }

  void _fetchGiftOffers() {
    _databaseReference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        final List<GiftOffer> offers = [];
        data.forEach((key, value) {
          final offer =
              GiftOffer.fromJson(Map<String, dynamic>.from(value), key);
          offers.add(offer);
        });
        setState(() {
          _giftOffers = offers;
        });
        // Debugging statement
        print('Gift offers fetched: $_giftOffers');
        _giftOffers.forEach((offer) => print('Image URL: ${offer.imageUrl}'));
      } else {
        setState(() {
          _giftOffers = [];
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
      // Show loading indicator while uploading
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismiss by tapping outside
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

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('gift_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putBlob(image);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Close the loading indicator dialog
      Navigator.pop(context);

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      // Close the loading indicator dialog in case of error
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

  Future<void> _updateGiftOffer(GiftOffer offer) async {
    final TextEditingController titleController =
        TextEditingController(text: offer.title);
    final TextEditingController descriptionController =
        TextEditingController(text: offer.description);
    final TextEditingController postDateController =
        TextEditingController(text: offer.postDate);
    final TextEditingController expiryDateController =
        TextEditingController(text: offer.expiryDate);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Gift Offer'),
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
                        labelText: 'Post Date ',
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
                        labelText: 'Expiry Date ',
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
                  await _databaseReference.child(offer.key).update(updatedData);
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

  Future<void> _deleteGiftOffer(String key) async {
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
                          'Manage Gifts',
                          textStyle: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        ScaleAnimatedText(
                          'Manage Gifts',
                          textStyle: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        ScaleAnimatedText(
                          'Manage Gifts',
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
                _buildGiftForm(),
                const SizedBox(height: 20),
                _buildGiftOffersList(),
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

  Widget _buildGiftForm() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController postDateController = TextEditingController();
    final TextEditingController expiryDateController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              dashPattern: const [6, 3],
              color: Colors.grey,
              child: IconButton(
                onPressed: _pickImage,
                icon: const Icon(Icons.camera_alt, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 10),
            if (_imageBytes != null)
              Image.memory(_imageBytes!, width: 100, height: 100),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          "Add Image",
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 30),
        TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Title',
            labelStyle: TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.white30,
            border: OutlineInputBorder(),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            labelStyle: TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.white30,
            border: OutlineInputBorder(),
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
          text: 'Send Gift Offer',
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
        const SizedBox(
          height: 30,
        ),
        MaterialButtons(
          textcolor: Colors.white,
          borderRadius: BorderRadius.circular(8),
          containerheight: 40,
          containerwidth: double.infinity,
          meterialColor: Colors.amber,
          elevationsize: 20,
          text: 'Gift to Users Activation',
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => GiftOffersPage()));
          },
        )
      ],
    );
  }

  Widget _buildGiftOffersList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _giftOffers.length,
      itemBuilder: (context, index) {
        final giftOffer = _giftOffers[index];

        // Parse the expiry date
        final DateTime expiryDate =
            DateFormat('yyyy-MM-dd').parse(giftOffer.expiryDate);
        final bool isExpired = DateTime.now().isAfter(expiryDate);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GiftActive(giftOffer: giftOffer),
              ),
            );
          },
          child: Card(
            color: Colors.white24,
            child: ListTile(
              leading: Image.network(
                giftOffer.imageUrl,
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
                      onTap: () => _launchURL(giftOffer.imageUrl),
                      child: Image.asset("assets/images/img.jpg"));
                },
              ),
              title: Text(
                giftOffer.title,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    giftOffer.description,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    'Posted on: ${giftOffer.postDate}',
                    style: const TextStyle(color: Colors.green),
                  ),
                  isExpired
                      ? AnimatedTextKit(
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
                        )
                      : Text(
                          'Expires on: ${DateFormat.yMMMd().format(expiryDate)}',
                          style: const TextStyle(
                            color: Colors.blue, // Blue for active
                          ),
                        ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () => _updateGiftOffer(giftOffer),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteGiftOffer(giftOffer.key),
                  ),
                ],
              ),
            ),
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
