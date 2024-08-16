import 'package:flutter/material.dart';

class CommonMethods
{
  Widget header(int headerFlexValue, String headerTitle)
  {
    return Expanded(
      
      flex: headerFlexValue,
      child: Container(
        decoration: const BoxDecoration(
        gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color.fromARGB(255, 12, 59, 131),Color.fromARGB(255, 4, 33, 76),],
      ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            headerTitle,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget data(int dataFlexValue, Widget widget)
  {
    return Expanded(
      flex: dataFlexValue,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: widget,
        ),
      ),
    );
  }
}