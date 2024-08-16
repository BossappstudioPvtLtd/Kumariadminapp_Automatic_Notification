import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:kumari_admin_web/Com/common_methods.dart';
import 'package:kumari_admin_web/data_fatching/driver_data.dart';

class DriversPage extends StatefulWidget
{
  static const String id = "\"webPageDrivers";

  const DriversPage({super.key});

  @override
  State<DriversPage> createState() => _DriversPageState();
}

class _DriversPageState extends State<DriversPage>
{
  CommonMethods cMethods = CommonMethods();
  

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.white,
      body:   Container(
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
                   child:    AnimatedTextKit(
                        animatedTexts: [
                          ScaleAnimatedText('Manage Drivers', textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.white),),
                          ScaleAnimatedText('Manage Drivers',textStyle: const TextStyle( fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white )),
                          ScaleAnimatedText('Manage Drivers',textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      
                      ),
                    ),
                ),
            
            
              
                const SizedBox(
                  height: 18,
                ),
                
            
                Row(
                  children: [
                    cMethods.header(2, "DRIVER ID"),
                    cMethods.header(1, "PICTURE"),
                    cMethods.header(1, "NAME"),
                    cMethods.header(1, "CAR DETAILS"),
                    cMethods.header(1, "PHONE"),
                    cMethods.header(1, "TOTAL EARNINGS"),
                    cMethods.header(1, "ACTION"),
                  ],
                ),
            
                //display data
                const DriversDataList(),
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
