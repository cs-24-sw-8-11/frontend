import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'package:frontend/custom_widgets/custom_iconbutton.dart';
import 'package:frontend/custom_widgets/global_color.dart';
import 'package:frontend/custom_widgets/custom_diag.dart';

import 'package:frontend/login_screen/register_page_manager.dart';

import 'package:frontend/main.dart';

class QuestionWidget extends StatefulWidget {
  final String header;
  final String metatext;
  final int index;
  final String questionID;
  final List<String> legends;

  const QuestionWidget({super.key, required this.header, required this.metatext, required this.index, required this.questionID, required this.legends});

  @override
  State<QuestionWidget> createState() => QuestionWidgetState();
}

class QuestionWidgetState extends State<QuestionWidget>{
  String? dropdownValue;
  int qlength = 9;
  bool isPressed = false;
  TextEditingController txtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    resetState();
  }

  void resetState() {
    setState(() {
      dropdownValue = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    RegisterProvider rpp = Provider.of<RegisterProvider>(context, listen: false);
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            rpp.returnIndex() == 7
            ? SizedBox( // Text Container
                height: (MediaQuery.of(context).size.height)*0.1,
                width: (MediaQuery.of(context).size.width)*0.5,
                child: Center(child: renderTextField()),
              )
            : renderDropdown(),
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1)),
            SizedBox(
              width: (MediaQuery.of(context).size.width) * 0.75,
              child: Row( //Nav Buttons
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  rpp.returnIndex() != 0
                  ? CustomIconButton(
                    icon: const Icon(Icons.arrow_back),
                    tooltipstring: "Back",
                    onPressed: () {
                      if (!isPressed) {
                        dropdownValue = null;
                        rpp.decrementIndex();
                      }
                    }
                  )
                  : const SizedBox.shrink(),
                  const Spacer(),
                  rpp.returnIndex() != qlength-1
                  ? CustomIconButton(
                    icon: const Icon(Icons.arrow_forward),
                    tooltipstring: "Next",
                    onPressed: () {
                      if (rpp.returnIndex() == 7 && txtController.text != "") {
                        rpp.updateCache(txtController.text, rpp.returnIndex());
                        rpp.incrementIndex();
                      }
                      else if (dropdownValue != null) {
                        rpp.updateCache(dropdownValue!, rpp.returnIndex());
                        dropdownValue = null;
                        rpp.incrementIndex();
                      }
                      else {
                        dialogBuilder(context, "Error", "Please answer the question before proceeding.");
                      }
                    }
                  )
                  : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.3,
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
                        if (dropdownValue != null) {
                          if (isPressed != true) {
                            setState(() => isPressed = true);
                            rpp.updateCache(dropdownValue!, rpp.returnIndex());
                            Response res = await rpp.submitRegisterCache(context, Provider.of<AuthProvider>(context, listen: false).fetchToken());
                            if (context.mounted) {
                              if (res.statusCode == 200) {
                                await dialogBuilder(context, "Success", res.body);
                              }
                              else {
                                await dialogBuilder(context, "Unexpected Error - ${res.statusCode}", res.body);
                              }
                              rpp.clearCache();
                              setState(() => isPressed = false);
                              rpp.changeState();
                              if (context.mounted) {
                                rpp.navigatorPop(context);
                              }
                            }
                          }
                        }
                        else {
                          dialogBuilder(context, "Error", "Please answer the question before proceeding.");
                        }
                      },
                    ),
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget renderTextField() {
    return TextField(
      controller: txtController,
      style: const TextStyle(color: globalTextColor),
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintStyle: TextStyle(color: globalFadedTextColor),
        hintText: "Answer",
      ),
    );
  }

  Widget renderDropdown() {
    return DropdownButton<String>(
      value: dropdownValue,
      elevation: 8,
      focusColor: globalScaffoldBackgroundColor,
      dropdownColor: globalScaffoldBackgroundColor,
      style: const TextStyle(color: globalTextColor),
      hint: const Text("Select", style: TextStyle(color: globalTextColor)),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      items: widget.legends.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(color: globalTextColor)),
        );
      }).toList(),
    );
  }
}