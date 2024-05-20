import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'package:frontend/custom_widgets/custom_iconbutton.dart';
import 'package:frontend/custom_widgets/custom_diag.dart';
import 'package:frontend/custom_widgets/global_color.dart';

import 'package:frontend/data_structures/answer.dart';
import 'package:frontend/data_structures/enums.dart';

import 'package:frontend/home_screen/home.dart';

import 'package:frontend/main.dart';

class JournalWidget extends StatefulWidget {
  final String header;
  final String metatext;
  final int index;
  final String questionID;
  final Function resetQuestionsCallback;

  const JournalWidget({super.key, required this.header, required this.metatext, required this.index, required this.questionID, required this.resetQuestionsCallback});

  @override
  State<JournalWidget> createState() => JournalWidgetState();
}

class JournalWidgetState extends State<JournalWidget>{
  List<JournalRating> opts = JournalRating.values;
  JournalRating _rating = JournalRating.none;
  int questionCount = 5;

  TextEditingController txtController = TextEditingController();
  bool isPressed = false;

  @override
  void initState() {
    super.initState();
    resetState();
  }

  void resetState() {
    setState(() {
      _rating = JournalRating.none;
      txtController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    HomePageProvider hpp = Provider.of<HomePageProvider>(context, listen: false);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1)),
          SizedBox( // Question Container
            height: (MediaQuery.of(context).size.height)*0.2,
            width: (MediaQuery.of(context).size.width)*0.9,
            child: Column(
              children: [
                Center(
                  child: Text(
                    widget.header,
                    style: const TextStyle(
                      color: globalTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 28
                    )
                  )
                ),
                Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03)),
                Center(
                  child: Text(
                    widget.metatext,
                    style: const TextStyle(
                      color: globalTextColor,
                      fontSize: 16
                    )
                  )
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05)),
          SizedBox( // Text Container
            height: (MediaQuery.of(context).size.height) * 0.1,
            width: (MediaQuery.of(context).size.width) * 0.9,
            child: Center(child: renderTextField()),
          ),
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.07)),
          Container( // Rating Container
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Rating",
                      style: TextStyle(
                        color: globalTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 28
                      )
                    ),
                    Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02)),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '?',
                            style: const TextStyle(fontSize: 24, decoration: TextDecoration.underline, color: globalUnderlineColor),
                            recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              dialogBuilder(context, "Legend", returnLegend());
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(questionCount-1, (index) => renderRadioButton(index+1, opts[index+1])),
                ),
              ],
            )
          ),
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05)),
          SizedBox(
            width: (MediaQuery.of(context).size.width) * 0.75,
            child: Row( //Nav Buttons
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                hpp.returnIndex() != 0
                ? CustomIconButton(
                  icon: const Icon(Icons.arrow_back),
                  tooltipstring: "Back",
                  onPressed: () {
                    if (!isPressed) {
                      hpp.decrementIndex();
                    }
                  }
                )
                : const SizedBox.shrink(),
                const Spacer(),
                hpp.returnIndex() != questionCount-1
                ? CustomIconButton(
                  icon: const Icon(Icons.arrow_forward),
                  tooltipstring: "Next",
                  onPressed: () {
                    if (txtController.text != "" && _rating != JournalRating.none) {
                      hpp.updateCache(PostAnswer(widget.questionID, txtController.text, _rating.index.toString()),hpp.returnIndex());
                      hpp.incrementIndex();
                    }
                    else {
                      dialogBuilder(context, "Error", "Please give both an answer and a rating before proceeding");
                    }
                  }
                )
                : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.225,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: globalButtonBackgroundColor,
                      disabledBackgroundColor: globalButtonDisabledBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: !isPressed
                    ? const Text(
                      "Submit",
                      style: TextStyle(color: globalTextColor),
                    )
                    : const SpinKitSquareCircle(
                      color: globalAnimationColor,
                      size: 20,
                    ),
                    onPressed: () async {
                      if (txtController.text != "" && _rating != JournalRating.none && isPressed != true) {
                        setState(() => isPressed = true);
                        hpp.updateCache(PostAnswer(widget.questionID, txtController.text, _rating.index.toString()),hpp.returnIndex());
                        Response res = await hpp.submitJournalCache(context, Provider.of<AuthProvider>(context, listen: false).fetchToken());
                        if (context.mounted) {
                          if (res.statusCode == 200) {
                            await dialogBuilder(context, "Success", res.body);
                            widget.resetQuestionsCallback();
                          }
                          else {
                            await dialogBuilder(context, "Unexpected Error - ${res.statusCode}", res.body);
                            widget.resetQuestionsCallback();
                          }
                          hpp.clearCache();
                          setState(() => isPressed = false);
                          hpp.changeState();
                        }
                      }
                      else {
                        dialogBuilder(context, "Error", "Please give both an answer and a rating before proceeding");
                      }
                    },
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }

  Widget renderTextField() {
    return TextField(
      controller: txtController,
      style: const TextStyle(color: globalTextColor),
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintStyle: TextStyle(color: globalFadedTextColor),
        hintText: "Answer",
      ),
    );
  }

  Widget renderRadioButton(int label, JournalRating opt) {
    return Column(
      children: <Widget>[
        Radio<JournalRating>(
          value: opt,
          groupValue: _rating,
          onChanged: (JournalRating? value) {
            setState(() {
              _rating = value!;
            });
          },
        ),
        Text('$label', style: const TextStyle(color: globalTextColor))
      ]
    );
  }

  String returnLegend(){
    return '1: Did not apply to me at all\n2: Applied to me to some degree, or some of the time\n3: Applied to me to a considerable degree, or a good part of the time\n4: Applied to me very much, or most of the time';
  }
}