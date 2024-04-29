import 'package:flutter/material.dart';
import 'package:frontend/custom_widgets/global_color.dart';

class DecisionWidget extends StatelessWidget{
  final String header;
  final String metatext;

  const DecisionWidget( {super.key, required this.header, required this.metatext});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: (MediaQuery.of(context).size.height)/3,
        width: (MediaQuery.of(context).size.width)*0.9,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: globalBorderBackgroundColor),
          borderRadius: const BorderRadius.all(Radius.circular(20))
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                header,
                style: const TextStyle(
                  color: globalTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 28
                )
              )
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                metatext,
                style: const TextStyle(
                  color: globalTextColor,
                  fontSize: 16
                )
              )
            ),
          ],
        ),
      )
    );
  }
}

class SliderWidget extends StatelessWidget{
  final String header;
  final String metatext;

  const SliderWidget( {super.key, required this.header, required this.metatext});

  @override
  Widget build(BuildContext context) {
    return Center(
      
    );
  }
}