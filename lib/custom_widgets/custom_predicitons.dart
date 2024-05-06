import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:frontend/main.dart';

import 'package:frontend/custom_widgets/global_color.dart';

import 'package:frontend/data_structures/user_data.dart';
import 'package:frontend/data_structures/prediction.dart';

import 'package:frontend/scripts/api_handler.dart';

import 'package:fl_chart/fl_chart.dart';

Widget predictionPage(
    BuildContext context, Function(String) updateApiText, apiText) {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      //mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(top: 15),
            child: ElevatedButton(
              onPressed: () async {
                String token = Provider.of<AuthProvider>(context, listen: false)
                    .fetchToken();
                List<Prediction> predictions = await getPredictionData(token);
                String predictionString = '';
                for (Prediction pred in predictions) {
                  predictionString += "${pred.value}\n";
                }
                updateApiText(predictionString);
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
            child: mitigationBox(context, "Mitigation Title", "Mitigation description that will tell the user something to make them less stress. This is supposed to be a much longer text than the title and therefore this string will test how it looks with a long text.")),
        Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
                padding: const EdgeInsets.all(15),
                height: (MediaQuery.of(context).size.height) * 0.4,
                width: (MediaQuery.of(context).size.width) * 0.9,
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
                        spots: _generatePoints([5, 2, 8, 3, 6, 3, 8, 1]),
                      )
                    ]))
                //child: Text(apiText, style: const TextStyle(color: globalTextColor)),
                )),
      ],
    ),
  );
}

Widget mitigationBox(BuildContext context, title, description) {
  return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.3,
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
          Padding(padding: const EdgeInsets.only(top:5), child:
          Text(description, style: const TextStyle(color: globalTextColor)))
        ],
      )));
}

Future<UserData> _fetchUserData(BuildContext context) async {
  String token = Provider.of<AuthProvider>(context, listen: false).fetchToken();
  return await getUserData(token);
}

List<FlSpot> _generatePoints(List<double> points) {
  List<FlSpot> spots = [];
  for (double i = 0; i < points.length; i++) {
    spots.add(FlSpot(i, points[i.floor()]));
  }
  return spots;
}