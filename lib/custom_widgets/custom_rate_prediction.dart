import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/custom_widgets/custom_diag.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'package:frontend/custom_widgets/global_color.dart';

import 'package:frontend/data_structures/prediction.dart';

import 'package:frontend/scripts/api_handler.dart';

import 'package:frontend/main.dart';

class PredictionRatingPage extends StatefulWidget {
  final List<double> predictionPoints;
  const PredictionRatingPage(this.predictionPoints, {super.key});

  @override
  PredictionRatingPageState createState() => PredictionRatingPageState();
}

class PredictionRatingPageState extends State<PredictionRatingPage> {
  double sliderValue = 0;
  String sliderLabel = '0';
  String currentPredictionValue = '';
  String token = '';
  @override
  Widget build(BuildContext context) {
    List<double> predictionPoints = widget.predictionPoints;
    currentPredictionValue = predictionPoints.last.toString();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globalAppBarColor,
        iconTheme: const IconThemeData(
          color: globalnavigatorArrowColor,
        ),
        title: const Text('Stress Handler', style: TextStyle(color: globalTextColor)),
        centerTitle: true,
      ),
      backgroundColor: globalScaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01)),
            const Text(
              'Rate Prediction',
              style: TextStyle(
                color: globalTextColor,
                fontSize: 25,
                fontWeight: FontWeight.bold
              )
            ),
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01)),
            Container(
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
              child: LineChart(
                LineChartData(
                  maxY: 5,
                  borderData: FlBorderData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      axisNameWidget: const Text('Time', style: TextStyle(color: globalTextColor)),
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
                            )
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      axisNameWidget: const Text('Stress', style: TextStyle(color: globalTextColor)),
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
                            )
                          );
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
              ),
            ),
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01)),
            Text('Current Prediction: $currentPredictionValue', style: const TextStyle(color: globalTextColor)),
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01)),
            Slider(
              value: sliderValue,
              max: 10,
              divisions: 10,
              label: sliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  sliderValue = value;
                  sliderLabel = sliderValue.round().toString();
                  currentPredictionValue = predictionPoints.last.toString();
                });
              },
            ),
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01)),
            Text('Rating: $sliderLabel', style: const TextStyle(color: globalTextColor)),
            const Expanded(
              child: SizedBox.shrink(),
            ),
            ElevatedButton(
              onPressed: () async {
                token = Provider.of<AuthProvider>(context, listen: false).fetchToken();
                String pid = (await getPredictionData(token)).last.id;
                Response response = await executeTestRating(token, pid, sliderLabel);
                if(context.mounted){
                  await dialogBuilder(context, '${response.statusCode}', response.body);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: globalButtonBackgroundColor,
                disabledBackgroundColor: globalButtonDisabledBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: const Text('Submit Rating', style: TextStyle(color: globalTextColor)),
            ),
            Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.05))
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
