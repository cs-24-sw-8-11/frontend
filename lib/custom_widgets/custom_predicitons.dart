import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:frontend/main.dart';

import 'package:frontend/custom_widgets/global_color.dart';

import 'package:frontend/data_structures/user_data.dart';
import 'package:frontend/data_structures/prediction.dart';

import 'package:frontend/scripts/api_handler.dart';

import 'package:fl_chart/fl_chart.dart';

Widget predictionPage(BuildContext context, Function(String) updateApiText, apiText) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () async {
              String token = Provider.of<AuthProvider>(context, listen: false).fetchToken();
              List<Prediction> predictions = await getPredictionData(token);
              String predictionString = '';
              for(Prediction pred in predictions){
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
            child: const Text('New Prediction', style: TextStyle(color: globalTextColor)),
          ),
          Expanded(
            child: Container(
              //color: Colors.grey,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 1),
                        FlSpot(1, 1),
                        FlSpot(1, 2),
                        FlSpot(2, 3),
                        FlSpot(3, 5),
                      ]
                    )
                  ]
                )
              )
              //child: Text(apiText, style: const TextStyle(color: globalTextColor)),
            ),
          ),

          const Padding(padding: EdgeInsets.only(bottom: 25)),
        ],
      ),
    );
  }

  Future<UserData> _fetchUserData(BuildContext context) async {
    String token = Provider.of<AuthProvider>(context, listen: false).fetchToken();
    return await getUserData(token);
  }