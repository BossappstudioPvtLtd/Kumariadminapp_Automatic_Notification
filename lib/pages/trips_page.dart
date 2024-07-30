import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:kumari_admin_web/common_methods.dart';
import 'package:kumari_admin_web/data_fatching/trip_data.dart';


class TripsPage extends StatefulWidget
{
  static const String id = "\"webPageTrips";

  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage>
{
  CommonMethods cMethods = CommonMethods();

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
               Color.fromARGB(255, 4, 33, 76),
              Color.fromARGB(255, 6, 79, 188),
            ])        
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
                   child:AnimatedTextKit(
                          animatedTexts: [
                          ScaleAnimatedText('Manage Trips', textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.white ),),
                          ScaleAnimatedText('Manage Trips',textStyle: const TextStyle( fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white )),
                          ScaleAnimatedText('Manage Trips',textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      
                      ),
                    ),
                ),
               
              
            
                const SizedBox(
                  height: 18,
                ),
            
                Row(
                  children: [
                    cMethods.header(2, "TRIP ID"),
                    cMethods.header(1, "USER NAME"),
                    cMethods.header(1, "DRIVER NAME"),
                    cMethods.header(1, "CAR DETAILS"),
                    cMethods.header(1, "TIMING"),
                    cMethods.header(1, "FARE"),
                    cMethods.header(1, "VIEW DETAILS"),
                  ],
                ),
            
                //display data
            
                const TripsDataList(),
                const SizedBox(height: 50,),
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
                
                          Container(height: 4000,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
