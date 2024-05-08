import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'package:frontend/custom_widgets/custom_diag.dart';
import 'package:frontend/custom_widgets/global_color.dart';

import 'package:frontend/data_structures/prediction.dart';
import 'package:frontend/data_structures/journal.dart';
import 'package:frontend/data_structures/mitigation.dart';

import 'package:frontend/scripts/api_handler.dart';

import 'package:frontend/main.dart';

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});

  @override
  PredictionPageState createState() => PredictionPageState();
}

class PredictionPageState extends State<PredictionPage> {
  List<double> predictionPoints = [];
  List<Mitigation> mitigations = [];
  Mitigation mitigation = Mitigation.defaultMitigation();
  Random random = Random();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(top: 15),
              child: ElevatedButton(
                onPressed: () async {
                  String token = Provider.of<AuthProvider>(
                      context, listen: false)
                      .fetchToken();
                  List<Prediction> predictions = await getPredictionData(token);
                  List<Journal> journals = await getJournals(token);
                  if (journals.length < 3) {
                    if(context.mounted){
                      await dialogBuilder(context, "Not enough data!", "Please make sure you have made at least 3 journals. You currently have ${journals.length} journals.");
                    }
                  }
                  else{
                    mitigations = await getMitigationsWithTag('default');
                    setState(() {
                      mitigation = mitigations[random.nextInt(mitigations.length)];
                      predictionPoints.clear();
                      for (Prediction pred in predictions) {
                        double? result = double.tryParse(pred.value);
                        if(result != null){
                          predictionPoints.add(result);
                        }
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: globalButtonBackgroundColor,
                  disabledBackgroundColor: globalButtonDisabledBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: const Text('New Prediction',
                    style: TextStyle(color: globalTextColor)),
              )),
          Padding(
              padding: const EdgeInsets.only(top: 15),
              child: mitigationBox(context, mitigation.title, mitigation.description, mitigation.type, mitigation.tags)),
          Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                  padding: const EdgeInsets.all(15),
                  height: (MediaQuery
                      .of(context)
                      .size
                      .height) * 0.4,
                  width: (MediaQuery
                      .of(context)
                      .size
                      .width) * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                      color: Colors.black, // Border color
                      width: 2, // Border width
                    ),
                  ),
                  child: LineChart(LineChartData(
                      borderData: FlBorderData(show: true),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          axisNameWidget: const Padding(
                              padding: EdgeInsets.only(),
                              child: Text('Time',
                                  style: TextStyle(color: globalTextColor))),
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
                                        color: globalTextColor, fontSize: 15),
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
                                  style: TextStyle(color: globalTextColor))),
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, titleMeta) {
                              return SideTitleWidget(
                                  axisSide: titleMeta.axisSide,
                                  space: 4,
                                  child: Text(
                                    value.toStringAsFixed(0),
                                    style: const TextStyle(
                                        color: globalTextColor, fontSize: 15),
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
                      ]))
                //child: Text(apiText, style: const TextStyle(color: globalTextColor)),
              )),
        ],
      ),
    );
  }

  Widget mitigationBox(BuildContext context, title, description, type, tags) {
    return Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.9,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.3,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            color: Colors.black, // Border color
            width: 2, // Border width
          ),
        ),
        child: Center(
            child: Column(
              children: [
                Text(title,
                    style: const TextStyle(
                        color: globalTextColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
                Padding(padding: const EdgeInsets.only(top: 5), child:
                Text(description,
                    style: const TextStyle(color: globalTextColor))),
                Expanded(child: Stack(children: [Align(alignment: Alignment.bottomLeft, child: Text('tags: ${tags.join(', ')}',
                    style: const TextStyle(color: globalTextColor, fontSize: 10))), Align(alignment: Alignment.bottomRight, child: Text('type: ${type == '1' ? 'short term' : 'long term'}',
                    style: const TextStyle(color: globalTextColor, fontSize: 10)))]))
              ],
            )));
  }

  List<FlSpot> _generatePoints(List<double> points) {
    List<FlSpot> spots = [];
    spots.add(FlSpot.zero);
    for (double i = 0; i < points.length; i++) {
      spots.add(FlSpot(i+1, points[i.floor()]));
    }
    return spots;
  }
}
