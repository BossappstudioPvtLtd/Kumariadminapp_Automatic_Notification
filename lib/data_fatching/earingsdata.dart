import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kumari_admin_web/Com/m_button.dart';

class CombinedDataPage extends StatefulWidget {
  const CombinedDataPage({super.key});

  @override
  State<CombinedDataPage> createState() => _CombinedDataPageState();
}

class _CombinedDataPageState extends State<CombinedDataPage> {
  final driversRef = FirebaseDatabase.instance.ref().child("drivers");
  final tripsRef = FirebaseDatabase.instance.ref().child("tripRequests");

  void _showDriverDetails(BuildContext context, Map<String, dynamic> driver) {
    final carDetails = driver["car_details"] ?? {};
    final carSeats = carDetails["carSeats"] ?? "N/A";
    final carModel = carDetails["carModel"] ?? "N/A";
    final carNumber = carDetails["carNumber"] ?? "N/A";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Driver Details"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("ID: ${driver["id"] ?? "N/A"}"),
              Text("Name: ${driver["name"] ?? "N/A"}"),
              Text("Phone: ${driver["phone"] ?? "N/A"}"),
              Text("Earnings: ₹ ${driver["earnings"] ?? '0'}"),
              Text("Car Seats: $carSeats"),
              Text("Car Model: $carModel"),
              Text("Car Number: $carNumber"),
              Text("Block Status: ${driver["blockStatus"] ?? "N/A"}"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDriverTrips(BuildContext context, String driverID, String driverName, String driverPhone) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) =>Dialog(
  child: Container(
    padding: EdgeInsets.all(16.0),
    decoration: BoxDecoration(
       gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: const [
                Color.fromARGB(255, 12, 59, 131),
                Color.fromARGB(255, 4, 33, 76),
              ],
            ),
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Completed Trips for Driver ID: $driverID", style: _dialogTitleStyle),
              Text("Name: $driverName", style: _dialogTitleStyle),
              Text("Phone: $driverPhone", style: _dialogTitleStyle),
            ],
          ),
          const SizedBox(height: 16.0),
          SingleChildScrollView(
            child: StreamBuilder(
              stream: tripsRef.orderByChild("driverID").equalTo(driverID).onValue,
              builder: (context, snapshot) {
                if (snapshot.hasError) return _errorWidget;
                if (snapshot.connectionState == ConnectionState.waiting) return _loadingWidget;
      
                final dataMap = snapshot.data?.snapshot.value as Map<dynamic, dynamic>? ?? {};
                if (dataMap.isEmpty) return _noDataWidget;
      
                double totalCommission = 0.0;
                final rows = dataMap.entries.map((entry) {
                  final trip = entry.value as Map<dynamic, dynamic>;
                  final fareAmount = double.tryParse(trip["fareAmount"]?.toString() ?? '0') ?? 0.0;
                  final commissionAmount = fareAmount * 0.10;
                  totalCommission += commissionAmount;
      
                  return DataRow(
                    cells: [
                      DataCell(Text(trip["dropOffAddress"] ?? "N/A",style: TextStyle(color:Colors.white),)),
                      DataCell(Text(trip["pickUpAddress"] ?? "N/A",style: TextStyle(color:Colors.white),)),
                      DataCell(Text("₹ ${fareAmount.toStringAsFixed(2)}",style: TextStyle(color:Colors.white),)),
                      DataCell(Text("₹ ${commissionAmount.toStringAsFixed(2)}",style: TextStyle(color:Colors.white),)),
                      DataCell(Text(trip["publishDateTime"] ?? "N/A",style: TextStyle(color:Colors.white),)),
                    ],
                  );
                }).toList();
      
                FirebaseDatabase.instance.ref().child('drivers').child(driverID).update({'totalCommission': totalCommission});
      
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Trips Details", style: _sectionTitleStyle),
                    Container(color: Colors.grey[200], padding: _padding, child: Text("Review the trip records completed by the driver.", style: _sectionSubtitleStyle)),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Drop Off Address')),
                          DataColumn(label: Text('Pick Up Address')),
                          DataColumn(label: Text('Original Fare Amount')),
                          DataColumn(label: Text('Commission (10%)')),
                          DataColumn(label: Text('Publish Date Time')),
                        ],
                        rows: rows,
                        headingRowColor: MaterialStateColor.resolveWith((states) => Color.fromARGB(255, 4, 33, 76)),
                        headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text("Total Commission: ₹ ${totalCommission.toStringAsFixed(2)}", style: _totalCommissionStyle),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16.0),
          Align(
            alignment: Alignment.centerRight,
            child: MaterialButtons(
              onTap: () => Navigator.of(context).pop(),
               containerheight: 40,
               containerwidth: 100,
               meterialColor: Colors.black,
              text: 'Close',
              textcolor: Colors.white, elevationsize: 20,
            ),
          ),
        ],
      ),
    ),
  ),
),

    );
  }

  String _formatCurrency(dynamic amount) {
    final formatter = NumberFormat.currency(locale: 'en_US', symbol: '', decimalDigits: 2);
    final parsedAmount = double.tryParse(amount?.toString() ?? '');
    return formatter.format(parsedAmount ?? 0);
  }

  TextStyle get _dialogTitleStyle => TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255));
  TextStyle get _sectionTitleStyle => TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255));
  TextStyle get _sectionSubtitleStyle => TextStyle(fontSize: 14, color: Color.fromARGB(255, 90, 90, 90));
  TextStyle get _totalCommissionStyle => TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber);
  EdgeInsets get _padding => const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0);
  Widget get _errorWidget => const Center(child: Text("Error Occurred. Try Later.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color.fromARGB(255, 4, 33, 76))));
  Widget get _loadingWidget => const Center(child: CircularProgressIndicator());
  Widget get _noDataWidget => const Center(child: Text("No data available.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color.fromARGB(255, 4, 33, 76))));
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder(
            stream: driversRef.onValue,
            builder: (context, snapshot) {
              if (snapshot.hasError) return _errorWidget;
              if (snapshot.connectionState == ConnectionState.waiting) return _loadingWidget;

              final dataMap = snapshot.data?.snapshot.value as Map<dynamic, dynamic>? ?? {};
              if (dataMap.isEmpty) return _noDataWidget;

              final groupedData = <String, List<Map<String, dynamic>>>{};
              dataMap.forEach((key, value) {
                if (value is Map) {
                  final driver = {"key": key, ...value.cast<String, dynamic>()};
                  final id = driver["id"] ?? "Unknown ID";
                  groupedData.putIfAbsent(id, () => []).add(driver);
                }
              });

              return ExpansionTile(
                iconColor: Colors.white,
              collapsedIconColor: Colors.white,
                title: const Text("Drivers List", style: TextStyle(color: Colors.white)),
                children: groupedData.entries.map((entry) {
                  final drivers = entry.value;
                  return Column(
                    children: drivers.map((driver) {
                      final carDetails = driver["car_details"] ?? {};
                      final carSeats = carDetails["carSeats"] ?? "N/A";
                      final carNumber = carDetails["carNumber"] ?? "N/A";

                      return Card(
                        color: Colors.white24,
                        child: ListTile(
                          
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(mainAxisAlignment:MainAxisAlignment.spaceAround,children:[ Text("$carSeats  $carNumber", style: TextStyle(color: Colors.white))]),
                              Row(mainAxisAlignment:MainAxisAlignment.spaceAround,children: [Icon(Icons.person, color: Colors.blue), Text(driver["name"]?.toString() ?? "N/A", style: TextStyle(color: Colors.white))]),
                              Row(mainAxisAlignment:MainAxisAlignment.spaceAround,children:[Icon(Icons.phone, color: Colors.green), Text(driver["phone"]?.toString() ?? "N/A", style: TextStyle(color: Colors.white))]),
                              Row(mainAxisAlignment:MainAxisAlignment.spaceAround,children: [Icon(Icons.currency_rupee_outlined, color: Colors.amber), Text(_formatCurrency(driver["totalCommission"]), style: TextStyle(color: Colors.white))]),
                            ],
                          ),
                          onTap: () => _showDriverTrips(context, driver["id"], driver["name"], driver["phone"]),
                          trailing: driver["blockStatus"] == "no"
                              ? _buildActionButton("Block", () => _updateBlockStatus(driver["id"], "Yes"))
                              : _buildActionButton("Approve", () => _updateBlockStatus(driver["id"], "no")),
                        ),
                      );
                    }).toList(),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  ElevatedButton _buildActionButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      child: Text(label),
    );
  }

  Future<void> _updateBlockStatus(String driverID, String status) async {
    await driversRef.child(driverID).update({"blockStatus": status});
  }
}
