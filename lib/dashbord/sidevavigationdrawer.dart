import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:kumari_admin_web/auth/admin_update.dart';
import 'package:kumari_admin_web/auth/login.dart';
import 'package:kumari_admin_web/dashbord/dash_bord.dart';
import 'package:kumari_admin_web/pages/advertisement.dart';
import 'package:kumari_admin_web/pages/driver_page.dart';
import 'package:kumari_admin_web/pages/earnings.dart';
import 'package:kumari_admin_web/pages/fere_page.dart';
import 'package:kumari_admin_web/pages/gift_page.dart';
import 'package:kumari_admin_web/pages/trips_page.dart';
import 'package:kumari_admin_web/pages/user_page.dart';// Import the login screen

class SideNavigationDrawer extends StatefulWidget {
  const SideNavigationDrawer({super.key});

  @override
  State<SideNavigationDrawer> createState() => _SideNavigationDrawerState();
}

class _SideNavigationDrawerState extends State<SideNavigationDrawer> {
  Widget chosenScreen = const Dashboard();

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Redirect to the LoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  void sendAdminTo(selectedPage) {
    switch (selectedPage.route) {
      case DriversPage.id:
        setState(() {
          chosenScreen = const DriversPage();
        });
        break;

      case UsersPage.id:
        setState(() {
          chosenScreen = const UsersPage();
        });
        break;

      case TripsPage.id:
        setState(() {
          chosenScreen = const TripsPage();
        });
        break;

      case FarePage.id:
        setState(() {
          chosenScreen = const FarePage();
        });
        break;
         case EarningsPage.id:
      setState(() {
        chosenScreen = const EarningsPage();
      });
     break;
      case GiftPage.id:
      setState(() {
        chosenScreen = const GiftPage();
      });
       break;
       case AdvertisementPage.id:
      setState(() {
        chosenScreen = const AdvertisementPage();
      });
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Color.fromARGB(255, 4, 33, 76),
                Color.fromARGB(255, 6, 79, 188),
              ])),
        ),
        title: AnimatedTextKit(
          totalRepeatCount: Duration.microsecondsPerMillisecond,
          animatedTexts: [
            WavyAnimatedText('Admin Web Panel',
                textStyle: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                )),
          ],
          isRepeatingAnimation: true,
        ),
      ),
      sideBar: SideBar(
        activeTextStyle: const TextStyle(color: Colors.white),
        textStyle: const TextStyle(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 4, 33, 76),
        activeBackgroundColor: const Color.fromARGB(255, 4, 33, 76),
        iconColor: Colors.white,
        activeIconColor: Colors.white,
        borderColor: Colors.black45,
        items: const [
          AdminMenuItem(
            title: "Drivers",
            route: DriversPage.id,
            icon: CupertinoIcons.car_detailed,
          ),
          AdminMenuItem(
            title: "Users",
            route: UsersPage.id,
            icon: CupertinoIcons.person_2_fill,
          ),
          AdminMenuItem(
            title: "Trips",
            route: TripsPage.id,
            icon: CupertinoIcons.location_fill,
          ),
          AdminMenuItem(
              title: "Fare",
              route: FarePage.id,
              icon: IconData(0xf05db, fontFamily: 'MaterialIcons')),
               AdminMenuItem(
            title: "Gift",
            route: GiftPage.id,
            icon: CupertinoIcons.gift_fill,
          ),
           AdminMenuItem(
              title: "Advertisement",
              route: AdvertisementPage.id,
            icon: CupertinoIcons.rectangle_3_offgrid_fill, ),
              AdminMenuItem(
              title: "Earnings",
              route: EarningsPage.id,
            icon:Icons.graphic_eq_sharp, ),
             
             
        ],
        selectedRoute: DriversPage.id,
        onSelected: (selectedPage) {
          sendAdminTo(selectedPage);
        },
        header: Container(
          height: 52,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                 showCupertinoModalPopup(context: context, builder: (BuildContext context){
                  return Center(
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                      height: 400,
                      width: 300,
                      child: const AdminUpdate()),
                  );
                 });
                },
                child: const Icon(
                  Icons.accessibility,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                 showDialog<void>(
    context: context,
    barrierDismissible: false, // User must tap a button to dismiss the dialog
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        elevation: 20,
        title: const Text(
          'Email Sign Out',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        content: const Text(
          'Do you want to continue with sign out?',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _signOut();
                  Navigator.of(context).pop(); // Close the dialog
                  // Redirect to login screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.green, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Continue'),
              ),
            ],
          ),
        ],
      );
    },
  );
                },
                child: const Icon(
                  Icons.power_settings_new_sharp,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ],
          ),
        ),
        footer: Container(
          height: 52,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.admin_panel_settings_outlined,
                color: Colors.white,
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.computer,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: chosenScreen,
    );
  }
}
