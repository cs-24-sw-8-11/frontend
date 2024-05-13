import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/login_screen/animation_route.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'package:frontend/custom_widgets/custom_diag.dart';
import 'package:frontend/custom_widgets/global_color.dart';

import 'package:frontend/data_structures/prediction.dart';
import 'package:frontend/data_structures/journal.dart';
import 'package:frontend/data_structures/mitigation.dart';

import 'package:frontend/scripts/api_handler.dart';

import 'package:frontend/main.dart';

class PredictionRatingPage extends StatefulWidget {
  const PredictionRatingPage({super.key});

  @override
  PredictionRatingPageState createState() => PredictionRatingPageState();
}

class PredictionRatingPageState extends State<PredictionRatingPage> {
  double sliderValue = 0;
  @override
  Widget build(BuildContext context) {
    List<double> predictionPoints = [];
    return Scaffold(
        appBar: AppBar(
          backgroundColor: globalAppBarColor,
          iconTheme: const IconThemeData(
            color: globalnavigatorArrowColor,
          ),
          title: const Text('Stress Handler',
              style: TextStyle(color: globalTextColor)),
          centerTitle: true,
        ),
        backgroundColor: globalScaffoldBackgroundColor,
        resizeToAvoidBottomInset: true,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01),
                  child: const Text('Rate Prediction',
                      style: TextStyle(
                          color: globalTextColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)
                  )
              ),
              Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    height: (MediaQuery.of(context).size.height) * 0.35,
                    width: (MediaQuery.of(context).size.width) * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(
                        color: Colors.black, // Border color
                        width: 2, // Border width
                      ),
                    ),
                    child: FutureBuilder(
                      builder: (ctx, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          predictionPoints.clear();
                          for (Prediction prediction in snapshot.data!) {
                            double? result = double.tryParse(prediction.value);
                            if (result != null) {
                              predictionPoints.add(result);
                            }
                          }
                          return LineChart(
                              LineChartData(
                                maxY: 5,
                                borderData: FlBorderData(show: true),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    axisNameWidget: const Padding(
                                        padding: EdgeInsets.only(),
                                        child: Text('Time',
                                            style:
                                            TextStyle(color: globalTextColor))),
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, titleMeta) {
                                        return SideTitleWidget(
                                            axisSide: titleMeta.axisSide,
                                            space: 4,
                                            child: Text(
                                              value % 1 == 0
                                                  ? value.toStringAsFixed(0)
                                                  : value.toStringAsFixed(1),
                                              style: const TextStyle(
                                                  color: globalTextColor,
                                                  fontSize: 15),
                                              textDirection: TextDirection.rtl,
                                              textAlign: TextAlign.center,
                                            ));
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    axisNameWidget: const Padding(
                                        padding: EdgeInsets.only(),
                                        child: Text('Stress',
                                            style:
                                            TextStyle(color: globalTextColor))),
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, titleMeta) {
                                        return SideTitleWidget(
                                            axisSide: titleMeta.axisSide,
                                            space: 4,
                                            child: Text(
                                              value.toStringAsFixed(0),
                                              style: const TextStyle(
                                                  color: globalTextColor),
                                              textDirection: TextDirection.rtl,
                                              textAlign: TextAlign.center,
                                            ));
                                      },
                                    ),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: _generatePoints(predictionPoints),
                                  )
                                ]
                            )
                          );
                        }
                      },
                      future: getPredictionData(
                          Provider.of<AuthProvider>(context, listen: false)
                              .fetchToken()),
                    ),
                    //child: Text(apiText, style: const TextStyle(color: globalTextColor)),
                  )
              ),
              Slider(
                value: sliderValue,
                max: 10,
                divisions: 10,
                label: sliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    sliderValue = value;
                  });
                },
              )
            ],
          ),
        )
    );
  }
  List<FlSpot> _generatePoints(List<double> points) {
    List<FlSpot> spots = [];
    spots.add(FlSpot.zero);
    for (double i = 0; i < points.length; i++) {
      spots.add(FlSpot(i + 1, points[i.floor()]));
    }
    return spots;
  }
}
