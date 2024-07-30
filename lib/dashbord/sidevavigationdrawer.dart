import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:kumari_admin_web/dashbord/dash_bord.dart';
import 'package:kumari_admin_web/pages/driver_page.dart';
import 'package:kumari_admin_web/pages/fere_oage.dart';
import 'package:kumari_admin_web/pages/trips_page.dart';
import 'package:kumari_admin_web/pages/user_page.dart';

class SideNavigationDrawer extends StatefulWidget {
  const SideNavigationDrawer({super.key});

  @override
  State<SideNavigationDrawer> createState() => _SideNavigationDrawerState();
}

class _SideNavigationDrawerState extends State<SideNavigationDrawer> {
  Widget chosenScreen = const Dashboard();

  sendAdminTo(selectedPage) {
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

         case  FarePage.id:
        setState(() {
          chosenScreen = const FarePage();
        });
        break;

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
            ])          
         ),        
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
      sideBar: SideBar
      (
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
            icon: IconData(0xf05db, fontFamily: 'MaterialIcons')
          ),
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
        colors: [Color.fromARGB(255, 12, 59, 131),Color.fromARGB(255, 4, 33, 76),],
      ),
        ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.accessibility,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ],
          ),
        ),
        footer: Container(
          height: 52,
          width: double.infinity, decoration: const BoxDecoration(
        gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color.fromARGB(255, 12, 59, 131),Color.fromARGB(255, 4, 33, 76),],
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
