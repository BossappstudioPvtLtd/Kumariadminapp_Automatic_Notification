import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kumari_admin_web/common_methods.dart';
import 'package:kumari_admin_web/data_fatching/gift_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'gift_page.dart'; // Import your GiftOffer model

class GiftActive extends StatefulWidget {
  final GiftOffer giftOffer;

  const GiftActive({super.key, required this.giftOffer});

  @override
  State<GiftActive> createState() => _GiftActiveState();
}

class _GiftActiveState extends State<GiftActive> {
  final CommonMethods cMethods = CommonMethods();

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
                      totalRepeatCount: 60,
                      animatedTexts: [
                        ScaleAnimatedText(
                          'Manage Gift Activation',
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
                Center(
                  child: Card(
                    elevation: 20,
                    child: Container(
                      height: 400,
                      width: 300,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            Color.fromARGB(255, 4, 33, 76),
                            Color.fromARGB(255, 6, 79, 188),
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          if (widget.giftOffer.imageUrl.isNotEmpty)
                            Image.network(
                              widget.giftOffer.imageUrl,
                              errorBuilder: (context, error, stackTrace) {
                                print('Image load error: $error');
                                print('Error details: ${stackTrace.toString()}');
                                return GestureDetector(
                                  onTap: () =>
                                      _launchURL(widget.giftOffer.imageUrl),
                                  child: Image.asset(
                                    "assets/images/img.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          const SizedBox(height: 18),
                          Text(
                            'Title: ${widget.giftOffer.title}',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Description: ${widget.giftOffer.description}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.white70),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Post Date: ${widget.giftOffer.postDate}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.green),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Expiry Date: ${widget.giftOffer.expiryDate}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    cMethods.header(2, "USER ID"),
                    cMethods.header(1, "USER NAME"),
                    cMethods.header(1, "USER EMAIL"),
                    cMethods.header(1, "PHONE"),
                    cMethods.header(1, "TOTAL TRIPS COMPLETED"),
                    cMethods.header(1, "ACTION"),
                  ],
                ),
                GiftData(onGiftOfferSelected: _sendGiftOfferToUser),
                const SizedBox(height: 50),
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
                ),
                Container(height: 4000),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _sendGiftOfferToUser(String userId) async {
    final DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child("users").child(userId);

    // Update the user's record with the selected gift offer
    await userRef.update({
      "giftOffer": {
        "title": widget.giftOffer.title,
        "description": widget.giftOffer.description,
        "imageUrl": widget.giftOffer.imageUrl,
        "postDate": widget.giftOffer.postDate,
        "expiryDate": widget.giftOffer.expiryDate,
      },
     // "giftStatus": "on",
    });

    // Optionally, you can navigate or show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Gift offer sent to the user!"),
      ),
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
