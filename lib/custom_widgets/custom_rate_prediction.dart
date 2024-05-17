import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'package:frontend/data_structures/enums.dart';

import 'package:frontend/custom_widgets/custom_diag.dart';
import 'package:frontend/custom_widgets/global_color.dart';

import 'package:frontend/scripts/api_handler.dart';

import 'package:frontend/main.dart';

class PredictionRatingPage extends StatefulWidget {
  final List<double> predictionPoints;
  final double userStress;
  const PredictionRatingPage(this.predictionPoints, this.userStress, {super.key});

  @override
  PredictionRatingPageState createState() => PredictionRatingPageState();
}

class PredictionRatingPageState extends State<PredictionRatingPage> {
  double sliderValue = 0;
  String sliderLabel = '0';
  String currentPredictionValue = '';
  String token = '';
  List<PredictionRating> opts = PredictionRating.values;
  PredictionRating _radioRating = PredictionRating.none;
  bool isLoading = false;

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
              'Rate Stress Prediction',
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
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02)),
            Text('Current Stress Prediction: $currentPredictionValue', style: const TextStyle(color: globalTextColor)),
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01)),
            const Text('Do you feel that the prediction is accurate?', style: TextStyle(color: globalTextColor)),
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate((opts.length)-1, (index) => renderRadioButton(index+1, opts[index+1])),
            ),
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02)),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: const Text('Please let us know if you feel that the current prediction is accurate by selecting Yes or No above. This will help tune the algorithm to be more accurate for your stress.', style: TextStyle(color: globalTextColor))),
            const Expanded(
              child: SizedBox.shrink(),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: ElevatedButton(
                onPressed: () async {
                  if(!isLoading){
                    setState(() {
                      isLoading = true;
                    });
                    token = Provider.of<AuthProvider>(context, listen: false).fetchToken();
                    int pid = (await getPredictionData(token)).last.id;
                    Response response = await executeTestRating(token, pid, widget.userStress.toStringAsFixed(1),(_radioRating.index-1).toString());
                    if(context.mounted){
                      await dialogBuilder(context, response.statusCode == 200 ? 'Success' : 'Error (${response.statusCode})', response.body);
                      if(context.mounted){
                        Navigator.of(context).pop();
                      }
                    }
                    setState(() {
                      isLoading = false;
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
                child: !isLoading ?
                const Text('Submit Rating', style: TextStyle(color: globalTextColor))
                : const SpinKitSquareCircle(color: globalAnimationColor, size: 20),
              ),
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

  Widget renderRadioButton(int label, PredictionRating opt) {
    return Column(
      children: <Widget>[
        Radio<PredictionRating>(
          value: opt,
          groupValue: _radioRating,
          onChanged: (PredictionRating? value) {
            setState(() {
              _radioRating = value!;
            });
          },
        ),
        Text(label == 1 ? 'Yes' : 'No', style: const TextStyle(color: globalTextColor))
      ]
    );
  }

}
