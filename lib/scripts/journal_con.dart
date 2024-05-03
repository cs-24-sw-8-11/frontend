import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/custom_widgets/custom_diag.dart';

import 'package:frontend/custom_widgets/global_color.dart';

import 'package:frontend/data_structures/options_enum.dart';

class DecisionWidget extends StatefulWidget {
  final String header;
  final String metatext;
  final bool renderlegend = true;

  const DecisionWidget( {super.key, required this.header, required this.metatext});

  @override
  State<DecisionWidget> createState() => DecisionWidgetState();
}

class DecisionWidgetState extends State<DecisionWidget>{
  List<Options> opts = Options.values;
  Options? _options = Options.none;
  int count = 5;
  final txtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget> [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 75),
            child: Column(
              children: <Widget>[
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
                  height: (MediaQuery.of(context).size.height)*0.2,
                  width: (MediaQuery.of(context).size.width)*0.9,
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
                      Row(
                        children: List.generate(count-1, (index) => renderRadioButton(index+1, opts[index+1])),
                      ),
                    ],
                  )
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10)
                ),
              ],
            )
          )
        ),
      ]
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

  Widget renderRadioButton(int label, Options opt) {
    return Flexible(
      child: RadioListTile<Options>(
        value: opt,
        groupValue: _options,
        onChanged: (Options? value) {
          setState(() {
            _options = value;
          });
        },
        title: Text('$label', style: const TextStyle(color: globalTextColor),)
      ),
    );
  }

  String returnLegend(){
    return '1: Did not apply to me at all\n2: Applied to me to some degree, or some of the time\n3: Applied to me to a considerable degree, or a good part of the time\n4: Applied to me very much, or most of the time';
    
  }
}