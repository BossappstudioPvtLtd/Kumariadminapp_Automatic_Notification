import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class GiftOffersPage extends StatefulWidget {
  @override
  _GiftOffersPageState createState() => _GiftOffersPageState();
}

class _GiftOffersPageState extends State<GiftOffersPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref('receivedGiftOffers');
  late Future<List<Map<String, dynamic>>> _giftOffersList;

  @override
  void initState() {
    super.initState();
    _giftOffersList = _fetchGiftOffers();
  }

  Future<List<Map<String, dynamic>>> _fetchGiftOffers() async {
    final snapshot = await _database.once();
    if (snapshot.snapshot.value != null) {
      final Map<dynamic, dynamic> data = snapshot.snapshot.value as Map<dynamic, dynamic>;
      return data.entries.map((entry) {
        final value = entry.value as Map<dynamic, dynamic>;
        return {
          'description': value['description'],
          'giftTitle': value['giftTitle'],
          'giftStatus': value['giftStatus'],
          'expiryDate': value['expiryDate'],
          'userName': value['userName'],
          'phone': value['phone'],
        };
      }).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
          Container(
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
            child: Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _giftOffersList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No gift offers available.'));
                  } else {
                    final giftOffers = snapshot.data!;
                    return ListView.builder(
                      itemCount: giftOffers.length,
                      itemBuilder: (context, index) {
                        final offer = giftOffers[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10.0,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Table(
  columnWidths: const {
    0: IntrinsicColumnWidth(), // Adjust column width as needed
  },
  children: [
    TableRow(
      children: [
        Text(
          'Gift Title:  ',
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          offer['giftTitle'],
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    ),
    TableRow(
      children: [
        const Text(
          'Description:  ',
          style: TextStyle(color: Colors.white70),
        ),
        Text(
          offer['description'],
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    ),
    TableRow(
      children: [
        const Text(
          'Status:  ',
          style: TextStyle(color: Colors.greenAccent),
        ),
        Text(
          offer['giftStatus'],
          style: const TextStyle(color: Colors.greenAccent),
        ),
      ],
    ),
    TableRow(
      children: [
        const Text(
          'Expiry Date:  ',
          style: TextStyle(color: Colors.redAccent),
        ),
        Text(
          offer['expiryDate'],
          style: const TextStyle(color: Colors.redAccent),
        ),
      ],
    ),
    TableRow(
      children: [
        const Text(
          'User Name:  ',
          style: TextStyle(color: Colors.white),
        ),
        Text(
          offer['userName'],
          style: const TextStyle(color: Colors.white),
        ),
      ],
    ),
    TableRow(
      children: [
        const Text(
          'Phone:  ',
          style: TextStyle(color: Colors.white70),
        ),
        Text(
          offer['phone'],
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    ),
  ],
)

                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
     
    );
  }
}
