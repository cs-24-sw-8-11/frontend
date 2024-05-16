import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/custom_widgets/custom_rate_prediction.dart';
import 'package:frontend/custom_widgets/custom_slider_diag.dart';
import 'package:frontend/login_screen/animation_route.dart';
import 'package:provider/provider.dart';

import 'package:frontend/custom_widgets/custom_diag.dart';
import 'package:frontend/custom_widgets/global_color.dart';

import 'package:frontend/data_structures/prediction.dart';
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
  List<Prediction> predictions = [];
  Mitigation mitigation = Mitigation.defaultMitigation();
  String token = '';
  double stressLevel = 0;
  double userPredictedStress = 0;
  bool hasMadeNewPrediction = false;
  bool isLoading = false;

  @override
  void initState(){
    token = Provider.of<AuthProvider>(context, listen: false).fetchToken();
    getPredictionData(token).then((data) {
      _refreshPredictionChartData(data);
      stressLevel = predictionPoints.isNotEmpty ? predictionPoints.last : 0;
    });
    getCuratedMitigation(token).then((data) {
      mitigation = data;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02)),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: ElevatedButton(
              onPressed: () async {
                if(!isLoading){
                  setState(() {
                    isLoading = true;
                  });
                  token = Provider.of<AuthProvider>(context, listen: false).fetchToken();
                  int journals = await getJournalCount(token);
                  if (journals < 3) {
                    if (context.mounted) {
                      await dialogBuilder(
                          context,
                          "Not enough data!",
                          "Please make sure you have made at least 3 journals. You currently have $journals journals."
                      );
                    }
                  }
                  else {
                    await executeNewPrediction(token);
                    predictions = await getPredictionData(token);
                    mitigation = await getCuratedMitigation(token);
                    setState(() {
                      hasMadeNewPrediction = true;
                      _refreshPredictionChartData(predictions);
                      stressLevel = predictionPoints.last;
                      mitigation = stressLevel > 1
                          ? mitigation
                          : Mitigation.defaultMitigation();
                    });
                    await _showUserStressPredictionDialog(predictions.last.id);
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
              const Text('New Prediction', style: TextStyle(color: globalTextColor))
              : const SpinKitSquareCircle(color: globalAnimationColor, size: 20),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01)),
          mitigationBox(
            context,
            mitigation.title,
            mitigation.description,
            mitigation.type,
            mitigation.tags,
          ),
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01)),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(_stressLevelToString(stressLevel), style: const TextStyle(color: globalTextColor)),
                Text('Current Stress Level: $stressLevel', style: const TextStyle(color: globalTextColor)),
              ],
            ),
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
                    axisNameWidget: const Text('Prediction Points',style: TextStyle(color: globalTextColor)),
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
                                fontSize: 15
                            ),
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                          )
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    axisNameWidget: const Text('Stress Level', style: TextStyle(color: globalTextColor)),
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, titleMeta) {
                      return SideTitleWidget(
                        axisSide: titleMeta.axisSide,
                        space: 4,
                        child: Text(
                          value.toStringAsFixed(0),
                          style: const TextStyle(color: globalTextColor),
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
            ),
          ),
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height)*0.01),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: ElevatedButton(
              onPressed: ()  {
                if(hasMadeNewPrediction){
                  Navigator.of(context).push(createRoute(PredictionRatingPage(predictionPoints, userPredictedStress)));
                }
                else{
                  dialogBuilder(context, 'No Prediction to rate', 'Please make a new prediction before rating');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: globalButtonBackgroundColor,
                disabledBackgroundColor: globalButtonDisabledBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: const Text('Rate Prediction', style: TextStyle(color: globalTextColor)),
            ),
          ),
        ],
      ),
    );
  }

  void _refreshPredictionChartData(List<Prediction> data) {
    setState(() {
      predictionPoints.clear();
      for (Prediction prediction in data) {
        double? result = double.tryParse(prediction.value);
        if (result != null) {
          predictionPoints.add(result);
        }
      }
    });
  }

  Widget mitigationBox(BuildContext context, title, description, type, tags) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.25,
      padding: const EdgeInsets.all(6),
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
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                color: globalTextColor,
                fontSize: 20,
                fontWeight: FontWeight.bold
              )
            ),
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01)),
            Text(description, style: const TextStyle(color: globalTextColor)),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text('tags: ${tags.join(', ')}', style: const TextStyle(color: globalTextColor, fontSize: 10))
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text('type: ${type == '1' ? 'short term' : 'long term'}', style: const TextStyle(color: globalTextColor, fontSize: 10))
                  ),
                ]
              )
            ),
          ],
        )
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

  String _stressLevelToString(double stressLevel) {
    if (stressLevel > 3) {
      return 'High Stress';
    } else if (stressLevel > 2) {
      return 'Moderate Stress';
    } else if (stressLevel > 1) {
      return 'Low Stress';
    }
    return 'No Stress';
  }

  Future<void> _showUserStressPredictionDialog(String pid) async {
    final selectedUserStress = await showDialog<double>(
      context: context,
      builder: (context) => SliderDialog(stressLevel),
    );

    if (selectedUserStress != null) {
      setState(() {
        userPredictedStress = selectedUserStress;
      });
    }
  }

  void updateStressLevel(double newStressLevel){
    setState(() {
      stressLevel = newStressLevel;
    });
  }
}
