import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:kumari_admin_web/common_methods.dart';
import 'package:kumari_admin_web/data_fatching/user_data.dart';

class UsersPage extends StatefulWidget
{
  static const String id = "\"webPageUsers";

  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  CommonMethods cMethods = CommonMethods();
  @override
  Widget build(BuildContext context)
  {
    return  Scaffold(
      backgroundColor: Colors.white,
      body:  Container(
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
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    height: 30,
                    alignment: Alignment.topLeft,
                   child:    AnimatedTextKit(
                        animatedTexts: [
                          ScaleAnimatedText('Manage Users', textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.white),),
                          ScaleAnimatedText('Manage Users',textStyle: const TextStyle( fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white )),
                          ScaleAnimatedText('Manage Users',textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.white )),
                        ],
                      
                      ),
                    ),
                ),
            
            const SizedBox(
              height: 18,
            ),
             Row(
              children: [
                cMethods.header(2, "USER ID"),
                cMethods.header(1, "USER NAME"),
                cMethods.header(1, "USER EMAIL"),
                cMethods.header(1, " PHONE"),
                cMethods.header(1, " ACTION"),
                
              ],
            ),
            const UsersDataList(),
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
      )
    );
  }
}
