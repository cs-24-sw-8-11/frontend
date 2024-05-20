import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart';

import 'package:frontend/login_screen/animation_route.dart';
import 'package:provider/provider.dart';

import 'package:frontend/custom_widgets/custom_diag.dart';
import 'package:frontend/custom_widgets/global_color.dart';
import 'package:frontend/custom_widgets/custom_rate_prediction.dart';
import 'package:frontend/custom_widgets/custom_slider_diag.dart';

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
  List<Mitigation> mitigations = [];
  List<Prediction> predictions = [];
  Mitigation mitigation = Mitigation.defaultMitigation();
  String token = '';
  double stressLevel = 0;
  double userPredictedStress = 0;
  bool hasMadeNewPrediction = false;
  bool isLoading = false;
  bool _isLoadingPrediction = true;

  @override
  void initState(){
    super.initState();
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return _predictionBody(); 
  }

  Widget _predictionBody() {
    if (_isLoadingPrediction) {
      return const Center(
        child: CircularProgressIndicator()
      );
    }

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
                          context.mounted ? context : context,
                          "Not enough data!",
                          "Please make sure you have made at least 3 journals. You currently have $journals journals."
                      );
                    }
                  }
                  else {
                    Response response = await executeNewPrediction(token);
                    if(response.statusCode == 200){
                      predictions = await getPredictionData(token);
                      mitigation = await getCuratedMitigation(token);
                      setState(() {
                        hasMadeNewPrediction = true;
                        stressLevel = double.parse(predictions.last.value);
                        mitigation = stressLevel > 1
                          ? mitigation
                          : Mitigation.defaultMitigation();
                      });
                      await _showUserStressPredictionDialog();
                    }
                    else{
                      if(context.mounted){
                        await dialogBuilder(context.mounted ? context : context, 'Error (${response.statusCode})', response.body == '' && response.statusCode == 500 ? 'Internal Server Error' : response.body);
                      }
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
            padding: const EdgeInsets.only(top:15, left: 15, right: 15, bottom: 10),
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
                minX: 0,
                minY: -1,
                maxX: 7,
                maxY: 5,
                borderData: FlBorderData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    axisNameSize: 20,
                    axisNameWidget: const Text('Time (Days)', style: TextStyle(color: globalTextColor)),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, titleMeta) {
                        return SideTitleWidget(
                          axisSide: titleMeta.axisSide,
                          space: 4,
                          child: Text(value.toStringAsFixed(0),
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
                    spots: _generatePoints(predictions),
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
                  Navigator.of(context).push(createRoute(PredictionRatingPage(predictions, userPredictedStress)));
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

  List<FlSpot> _generatePoints(List<Prediction> predictions) {
    List<FlSpot> spots = [];
    int oneWeekAgo = (DateTime.now().millisecondsSinceEpoch - 86400000 * 7) ~/ 1000;
    predictions = predictions.where((x) => (x.timeStamp - x.timeStamp % 86400) >= oneWeekAgo && x.timeStamp <= DateTime.now().millisecondsSinceEpoch ~/ 1000).toList();
    predictions.sort();
    for (int i = 0; i < predictions.length; i++) {
      int timestampOffset = (predictions.first.timeStamp - predictions.first.timeStamp % 86400);
      spots.add(FlSpot((predictions[i].timeStamp - timestampOffset) / 86400, double.parse(predictions[i].value)));
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

  Future<void> _showUserStressPredictionDialog() async {
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

  Future<void> _initializeData() async {
    final token = Provider.of<AuthProvider>(context, listen: false).fetchToken();

    final curatedMitigationFuture = getCuratedMitigation(token).then((data) {
      mitigation = data;
    });

    final predictionDataFuture = getPredictionData(token).then((data) {
      predictions = data;
      stressLevel = predictions.isNotEmpty ? double.parse(predictions.last.value) : 0;
    });

    // Wait for all futures to complete
    await Future.wait([curatedMitigationFuture, predictionDataFuture]);

    if(stressLevel < 1){
     mitigation = Mitigation.defaultMitigation();
    }
    // Update state after all futures have completed
    if (mounted) {
      setState(() {
        _isLoadingPrediction = false;
      });
    }
  }
}
