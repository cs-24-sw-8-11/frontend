import 'package:flutter/material.dart';
import 'package:frontend/custom_widgets/global_color.dart';
import 'package:frontend/data_structures/options_enum.dart';

class DecisionWidget extends StatefulWidget {
  final String header;
  final String metatext;

  const DecisionWidget( {super.key, required this.header, required this.metatext});

  @override
  State<DecisionWidget> createState() => DecisionWidgetState();
}

class DecisionWidgetState extends State<DecisionWidget>{
  Options? _options = Options.none;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget> [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 75),
            child: Column(
              children: <Widget>[
                Container(
                  height: (MediaQuery.of(context).size.height)*0.3,
                  width: (MediaQuery.of(context).size.width)*0.9,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: globalBorderBackgroundColor),
                    borderRadius: const BorderRadius.all(Radius.circular(20))
                  ),
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
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: RadioListTile<Options>(
                                value: Options.opt1,
                                groupValue: _options,
                                onChanged: (Options? value) {
                                  setState(() {
                                    _options = value;
                                  });
                                },
                                title: const Text('1', style: TextStyle(color: globalTextColor)),
                              ),
                            ),
                            Flexible(
                              child: RadioListTile<Options>(
                                value: Options.opt2,
                                groupValue: _options,
                                onChanged: (Options? value) {
                                  setState(() {
                                    _options = value;
                                  });
                                },
                                title: const Text('2', style: TextStyle(color: globalTextColor)),
                              ),
                            ),
                            Flexible(
                              child: RadioListTile<Options>(
                                value: Options.opt3,
                                groupValue: _options,
                                onChanged: (Options? value) {
                                  setState(() {
                                    _options = value;
                                  });
                                },
                                title: const Text('3', style: TextStyle(color: globalTextColor)),
                              ),
                            ),
                            Flexible(
                              child: RadioListTile<Options>(
                                value: Options.opt4,
                                groupValue: _options,
                                onChanged: (Options? value) {
                                  setState(() {
                                    _options = value;
                                  });
                                },
                                title: const Text('4', style: TextStyle(color: globalTextColor)),
                              ),
                            ),
                          ],
                        )
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30)
                ),
                SizedBox(
                  height: (MediaQuery.of(context).size.height)*0.3,
                  width: (MediaQuery.of(context).size.width)*0.9,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Legend:', style: TextStyle(color: globalTextColor)),
                      Text('1: Did not apply to me at all', style: TextStyle(color: globalTextColor)),
                      Text('2: Applied to me to some degree, or some of the time', style: TextStyle(color: globalTextColor)),
                      Text('3: Applied to me to a considerable degree, or a good part of the time', style: TextStyle(color: globalTextColor)),
                      Text('4: Applied to me very much, or most of the time', style: TextStyle(color: globalTextColor)),
                    ],
                  )
                )
              ],
            )
          )
        ),
      ]
    );
  }
}