import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:frontend/custom_widgets/custom_iconbutton.dart';
import 'package:frontend/custom_widgets/custom_diag.dart';
import 'package:frontend/custom_widgets/global_color.dart';

import 'package:frontend/data_structures/answer.dart';
import 'package:frontend/data_structures/enums.dart';

import 'package:frontend/home_screen/home.dart';

class QuestionWidget extends StatefulWidget {
  final String header;
  final String metatext;
  final int index;
  final String questionID;

  const QuestionWidget({super.key, required this.header, required this.metatext, required this.index, required this.questionID});

  @override
  State<QuestionWidget> createState() => QuestionWidgetState();
}

class QuestionWidgetState extends State<QuestionWidget>{
  List<JournalRating> opts = JournalRating.values;
  JournalRating _options = JournalRating.none;
  int count = 5;
  TextEditingController txtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    resetState();
  }

  void resetState() {
    setState(() {
      _options = JournalRating.none;
      txtController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    HomePageProvider hpp = Provider.of<HomePageProvider>(context, listen: false);
    return SingleChildScrollView(
      child: Column(
        children: <Widget> [
          Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 75),
              ),
              SizedBox( // Question Container
                height: (MediaQuery.of(context).size.height)*0.2,
                width: (MediaQuery.of(context).size.width)*0.9,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        widget.header,
                        style: const TextStyle(
                          color: globalTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 28
                        )
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
              const Padding(
                  padding: EdgeInsets.only(top: 30),
              ),
              SizedBox( // Text Container
                height: (MediaQuery.of(context).size.height)*0.1,
                width: (MediaQuery.of(context).size.width)*0.9,
                child: Center(child: renderTextField()),
              ),
              const Padding(
                  padding: EdgeInsets.only(top: 50),
              ),
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
                        const Padding(padding: EdgeInsets.only(left: 10)),
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
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(count-1, (index) => renderRadioButton(index+1, opts[index+1])),
                    ),
                  ],
                )
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10)
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
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
                        hpp.decrementIndex();
                      }
                    )
                    : const SizedBox.shrink(),
                    const Spacer(),
                    hpp.returnIndex() != count-1
                    ? CustomIconButton(
                      icon: const Icon(Icons.arrow_forward),
                      tooltipstring: "Next",
                      onPressed: () {
                        if (txtController.text != "" && _options != JournalRating.none) {
                          hpp.updateCache(PostAnswer(widget.questionID, txtController.text, _options.index.toString()),hpp.returnIndex());
                          hpp.incrementIndex();
                        }
                        else {
                          dialogBuilder(context, "Error", "Please give both an answer and a rating before proceeding");
                        }
                      }
                    )
                    : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: globalButtonBackgroundColor,
                        disabledBackgroundColor: globalButtonDisabledBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      onPressed: () {
                        hpp.updateCache(PostAnswer(widget.questionID, txtController.text, _options.index.toString()),hpp.returnIndex());
                        hpp.submitJournalCache(context); //remove context later
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(color: globalTextColor),
                      )
                    ),
                  ],
                )
              ),
            ],
          )
        ]
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
          groupValue: _options,
          onChanged: (JournalRating? value) {
            setState(() {
              _options = value!;
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