import 'package:flutter/material.dart';
import 'package:frontend/custom_widgets/global_color.dart';

class SliderDialog extends StatefulWidget {
  /// initial selection for the slider
  final double initialStress;

  const SliderDialog(this.initialStress, {super.key});

  @override
  SliderDialogState createState() => SliderDialogState();
}

class SliderDialogState extends State<SliderDialog> {
  /// current selection of the slider
  double stressLevelInput = 0;

  @override
  void initState() {
    super.initState();
    stressLevelInput = widget.initialStress;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2)),
        Center(
          child: AlertDialog(
            title: const Text('How stressed do you think you will be?'),
            content: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03)),
                Text(stressLevelInput.toStringAsFixed(1), style: const TextStyle(color: Colors.black87, fontSize: 20)),
                Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03)),
                Slider(
                  value: stressLevelInput,
                  min: 0,
                  max: 5,
                  divisions: 50,
                  onChanged: (value) {
                    setState(() {
                      stressLevelInput = value;
                    });
                  },
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                onPressed: () {
                  Navigator.pop(context, stressLevelInput);
                },
                child: const Text('Submit'),
              )
            ],
          ),
        ),
        Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1))
      ],
    );
  }
}